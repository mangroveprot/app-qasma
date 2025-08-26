import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';
import 'package:logger/logger.dart';

import '../../../../../common/error/app_error.dart';
import '../../domain/services/master_list_report_service.dart';
import '../config/master_list_report_config.dart';
import '../model/master_list_model.dart';

class MasterlistReportServiceImpl implements MasterlistReportService {
  static const _platform = MethodChannel('excel_saver');
  final Logger _logger;

  MasterlistReportServiceImpl({Logger? logger}) : _logger = logger ?? Logger();

  @override
  Future<Either<AppError, String>> generateReportFromTemplate({
    required List<MasterlistModel> entries,
    String templatePath = MasterlistConfig.defaultTemplatePath,
    String outputBaseName = MasterlistConfig.defaultOutputBaseName,
  }) async {
    if (entries.isEmpty) {
      return Left(AppError.create(
        message: 'No masterlist entries provided.',
        type: ErrorType.validation,
      ));
    }

    try {
      final excel = await _loadTemplate(templatePath);
      final sheet = _getFirstSheet(excel);

      await _populateData(sheet, entries);
      _autoFitColumns(sheet);

      final outputBytes = excel.save();
      if (outputBytes == null) {
        return Left(AppError.create(
          message: 'Failed to save Excel file - no output generated.',
          type: ErrorType.unknown,
        ));
      }

      final fileName = await _saveFile(outputBytes, outputBaseName);

      _logger.i('✅ Masterlist report generated with ${entries.length} entries');
      return Right(fileName);
    } on PlatformException catch (e, stackTrace) {
      _logger.e('Platform error generating masterlist report', e, stackTrace);
      return Left(AppError.create(
        message: 'Platform error: ${e.message ?? 'Unknown platform error'}',
        type: ErrorType.unknown,
        originalError: e,
        stackTrace: stackTrace,
      ));
    } on FileSystemException catch (e, stackTrace) {
      _logger.e(
          'File system error generating masterlist report', e, stackTrace);
      return Left(AppError.create(
        message: 'File system error: ${e.message}',
        type: ErrorType.unknown,
        originalError: e,
        stackTrace: stackTrace,
      ));
    } on AppError {
      rethrow;
    } catch (e, stackTrace) {
      _logger.e('Unexpected error generating masterlist report', e, stackTrace);
      return Left(AppError.create(
        message:
            'Unexpected error generating masterlist report: ${e.toString()}',
        type: ErrorType.unknown,
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Either<AppError, String>> generateReportFromMaps({
    required List<Map<String, dynamic>> rows,
    String templatePath = MasterlistConfig.defaultTemplatePath,
    String outputBaseName = MasterlistConfig.defaultOutputBaseName,
  }) async {
    try {
      final entries = rows.map((row) => MasterlistModel.fromMap(row)).toList();
      return await generateReportFromTemplate(
        entries: entries,
        templatePath: templatePath,
        outputBaseName: outputBaseName,
      );
    } catch (e, stackTrace) {
      _logger.e('Error converting maps to models', e, stackTrace);
      return Left(AppError.create(
        message: 'Failed to convert data format: ${e.toString()}',
        type: ErrorType.unknown,
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  // Convenience methods that throw exceptions
  Future<void> generateReportFromTemplateThrows({
    required List<MasterlistModel> entries,
    String templatePath = MasterlistConfig.defaultTemplatePath,
    String outputBaseName = MasterlistConfig.defaultOutputBaseName,
  }) async {
    final result = await generateReportFromTemplate(
      entries: entries,
      templatePath: templatePath,
      outputBaseName: outputBaseName,
    );

    result.fold(
      (error) => throw error,
      (fileName) => _logger.i('Report generated: $fileName'),
    );
  }

  Future<void> generateReportFromMapsThrows({
    required List<Map<String, dynamic>> rows,
    String templatePath = MasterlistConfig.defaultTemplatePath,
    String outputBaseName = MasterlistConfig.defaultOutputBaseName,
  }) async {
    final result = await generateReportFromMaps(
      rows: rows,
      templatePath: templatePath,
      outputBaseName: outputBaseName,
    );

    result.fold(
      (error) => throw error,
      (fileName) => _logger.i('Report generated: $fileName'),
    );
  }

  // Private helper methods remain the same
  Future<Excel> _loadTemplate(String templatePath) async {
    try {
      final ByteData data = await rootBundle.load(templatePath);
      final bytes = data.buffer.asUint8List();
      return Excel.decodeBytes(bytes);
    } on FlutterError catch (e) {
      throw AppError.create(
        message:
            'Template file not found: $templatePath. Please ensure the template exists in assets.',
        type: ErrorType.unknown,
        originalError: e,
      );
    } catch (e) {
      throw AppError.create(
        message: 'Failed to load template: ${e.toString()}',
        type: ErrorType.unknown,
        originalError: e,
      );
    }
  }

  Sheet _getFirstSheet(Excel excel) {
    if (excel.tables.isEmpty) {
      throw AppError.create(
        message: 'No sheets found in template file.',
        type: ErrorType.validation,
      );
    }

    final sheet = excel.tables[excel.tables.keys.first];
    if (sheet == null) {
      throw AppError.create(
        message: 'Template sheet is corrupted or unreadable.',
        type: ErrorType.validation,
      );
    }
    return sheet;
  }

  Future<void> _populateData(Sheet sheet, List<MasterlistModel> entries) async {
    try {
      final cellStyle = _createDataCellStyle();

      for (int i = 0; i < entries.length; i++) {
        final rowIndex = MasterlistConfig.dataStartRowIndex + i;
        final entry = entries[i];

        _insertMasterlistRow(sheet, rowIndex, entry, i + 1, cellStyle);
      }
    } catch (e) {
      throw AppError.create(
        message: 'Failed to populate data into Excel sheet: ${e.toString()}',
        type: ErrorType.unknown,
        originalError: e,
      );
    }
  }

  CellStyle _createDataCellStyle() {
    return CellStyle(
      fontFamily: getFontFamily(FontFamily.Calibri),
      fontSize: 12,
      bold: false,
      italic: false,
      leftBorder:
          Border(borderStyle: BorderStyle.Thin, borderColorHex: '#000000'),
      rightBorder:
          Border(borderStyle: BorderStyle.Thin, borderColorHex: '#000000'),
      topBorder:
          Border(borderStyle: BorderStyle.Thin, borderColorHex: '#000000'),
      bottomBorder:
          Border(borderStyle: BorderStyle.Thin, borderColorHex: '#000000'),
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      backgroundColorHex: '#FFFFFF',
      fontColorHex: '#000000',
    );
  }

  void _insertMasterlistRow(
    Sheet sheet,
    int rowIndex,
    MasterlistModel entry,
    int sequenceNumber,
    CellStyle cellStyle,
  ) {
    final data = {
      'No': entry.no ?? sequenceNumber.toString(),
      'Date': entry.date ?? '',
      'Name': entry.name ?? '',
      'Address': entry.address ?? '',
      'Contact No': entry.contactNo ?? '',
      'Purpose': entry.purpose ?? '',
      'Status': entry.status ?? '',
    };

    MasterlistConfig.columnIndices.forEach((columnName, columnIndex) {
      try {
        final cell = sheet.cell(CellIndex.indexByColumnRow(
          columnIndex: columnIndex,
          rowIndex: rowIndex,
        ));
        cell.value = data[columnName];
        cell.cellStyle = cellStyle;
      } catch (e) {
        throw AppError.create(
          message:
              'Failed to insert data at row $rowIndex, column $columnName: ${e.toString()}',
          type: ErrorType.unknown,
          originalError: e,
        );
      }
    });
  }

  void _autoFitColumns(Sheet sheet) {
    try {
      MasterlistConfig.columnWidths.forEach((columnIndex, defaultWidth) {
        final double optimalWidth =
            _calculateOptimalWidth(sheet, columnIndex, defaultWidth);
        sheet.setColWidth(columnIndex, optimalWidth);
      });
    } catch (e) {
      _logger.w('Warning: Failed to auto-fit columns: ${e.toString()}');
    }
  }

  double _calculateOptimalWidth(
      Sheet sheet, int columnIndex, double defaultWidth) {
    double maxContentWidth = defaultWidth;

    try {
      for (int row = MasterlistConfig.headerRowIndex;
          row < sheet.maxRows && row < 100;
          row++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(
          columnIndex: columnIndex,
          rowIndex: row,
        ));

        if (cell.value != null) {
          final contentLength = cell.value.toString().length * 1.1;
          if (contentLength > maxContentWidth) {
            maxContentWidth = contentLength;
          }
        }
      }
    } catch (e) {
      _logger.w(
          'Warning: Failed to calculate optimal width for column $columnIndex, using default');
      return defaultWidth;
    }

    return maxContentWidth.clamp(defaultWidth, 50.0);
  }

  Future<String> _saveFile(List<int> outputBytes, String baseName) async {
    final now = DateTime.now();
    final fileName =
        '${baseName}_${_padZero(now.day)}-${_padZero(now.month)}-${now.year}.xlsx';

    if (Platform.isAndroid) {
      await _saveToDownloads(Uint8List.fromList(outputBytes), fileName);
    } else {
      _logger.i('File ready for non-Android platform: $fileName');
    }

    return fileName;
  }

  String _padZero(int number) => number.toString().padLeft(2, '0');

  Future<void> _saveToDownloads(Uint8List bytes, String fileName) async {
    try {
      final result = await _platform.invokeMethod('saveToDownloads', {
        'fileName': fileName,
        'bytes': bytes,
        'mimeType':
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      });

      if (result['success'] == true) {
        _logger.i('✅ Masterlist file saved: $fileName');
      } else {
        throw AppError.create(
          message:
              result['error']?.toString() ?? 'Failed to save file to downloads',
          type: ErrorType.unknown,
        );
      }
    } on PlatformException catch (e) {
      throw AppError.create(
        message: 'Platform error saving file: ${e.message}',
        type: ErrorType.unknown,
        originalError: e,
      );
    } catch (e) {
      if (e is AppError) rethrow;
      throw AppError.create(
        message: 'Unexpected error saving file: ${e.toString()}',
        type: ErrorType.unknown,
        originalError: e,
      );
    }
  }
}
