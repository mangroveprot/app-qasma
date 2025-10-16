package com.jrmsu.qasma.counselor

import android.content.ContentValues
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.IOException

class MainActivity: FlutterActivity() {
    private val CAMERA_CHANNEL = "camera_release"
    private val EXCEL_CHANNEL = "excel_saver"
    private var cameraMethodChannel: MethodChannel? = null
    private var excelMethodChannel: MethodChannel? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        
        // Setup camera channel
        cameraMethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CAMERA_CHANNEL)
        cameraMethodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "releaseCamera" -> {
                    releaseCameraNative()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
        
        excelMethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, EXCEL_CHANNEL)
        excelMethodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "saveToDownloads" -> {
                    val fileName = call.argument<String>("fileName")
                    val bytes = call.argument<ByteArray>("bytes")
                    val mimeType = call.argument<String>("mimeType")
                    
                    if (fileName != null && bytes != null && mimeType != null) {
                        saveToDownloads(fileName, bytes, mimeType, result)
                    } else {
                        result.error("INVALID_ARGUMENTS", "Missing required arguments", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onPause() {
        super.onPause()
        // Call Flutter method to release camera
        cameraMethodChannel?.invokeMethod("releaseCamera", null, object : MethodChannel.Result {
            override fun success(result: Any?) {
                println("Camera release successful")
            }
            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                println("Camera release error: $errorMessage")
            }
            override fun notImplemented() {
                println("Camera release not implemented")
            }
        })
    }

    override fun onResume() {
        super.onResume()
        // Optional: Reinitialize camera when app resumes
        cameraMethodChannel?.invokeMethod("reinitializeCamera", null)
    }

    override fun onDestroy() {
        super.onDestroy()
        releaseCameraNative()
        cameraMethodChannel = null
        excelMethodChannel = null
    }

    private fun releaseCameraNative() {
        try {
            // Force release camera at system level
            System.gc() // Force garbage collection
            Runtime.getRuntime().gc()
        } catch (e: Exception) {
            println("Error releasing camera native: ${e.message}")
        }
    }

    private fun saveToDownloads(fileName: String, bytes: ByteArray, mimeType: String, result: MethodChannel.Result) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                // Android 10+ - Use MediaStore
                saveWithMediaStore(fileName, bytes, mimeType, result)
            } else {
                // Android 9 and below - Use legacy method
                saveLegacy(fileName, bytes, result)
            }
        } catch (e: Exception) {
            result.error("SAVE_ERROR", e.message, null)
        }
    }

    private fun saveWithMediaStore(fileName: String, bytes: ByteArray, mimeType: String, result: MethodChannel.Result) {
        val values = ContentValues().apply {
            put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
            put(MediaStore.MediaColumns.MIME_TYPE, mimeType)
            put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
        }

        val uri = contentResolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
        
        if (uri != null) {
            try {
                contentResolver.openOutputStream(uri)?.use { outputStream ->
                    outputStream.write(bytes)
                    outputStream.flush()
                }
                
                result.success(mapOf(
                    "success" to true,
                    "path" to "Downloads/$fileName"
                ))
            } catch (e: IOException) {
                contentResolver.delete(uri, null, null)
                result.error("WRITE_ERROR", "Failed to write file: ${e.message}", null)
            }
        } else {
            result.error("URI_ERROR", "Failed to create file URI", null)
        }
    }

    private fun saveLegacy(fileName: String, bytes: ByteArray, result: MethodChannel.Result) {
        try {
            val downloadsDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
            val file = java.io.File(downloadsDir, fileName)
            
            file.writeBytes(bytes)
            
            result.success(mapOf(
                "success" to true,
                "path" to file.absolutePath
            ))
        } catch (e: Exception) {
            result.error("LEGACY_SAVE_ERROR", "Failed to save file: ${e.message}", null)
        }
    }
}