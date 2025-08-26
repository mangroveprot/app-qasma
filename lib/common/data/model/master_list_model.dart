class MasterlistModel {
  final String? no;
  final String? date;
  final String? name;
  final String? address;
  final String? contactNo;
  final String? purpose;
  final String? status;

  const MasterlistModel({
    this.no,
    this.date,
    this.name,
    this.address,
    this.contactNo,
    this.purpose,
    this.status,
  });

  factory MasterlistModel.fromMap(Map<String, dynamic> map) {
    return MasterlistModel(
      no: map['No']?.toString(),
      date: map['Date']?.toString(),
      name: map['Name']?.toString(),
      address: map['Address']?.toString(),
      contactNo: map['Contact No']?.toString(),
      purpose: map['Purpose']?.toString(),
      status: map['Status']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'No': no,
      'Date': date,
      'Name': name,
      'Address': address,
      'Contact No': contactNo,
      'Purpose': purpose,
      'Status': status,
    };
  }

  @override
  String toString() {
    return 'MasterlistModel(no: $no, name: $name, date: $date)';
  }
}
