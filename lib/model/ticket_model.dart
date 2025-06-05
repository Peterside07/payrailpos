class TicketMessages {
  final String dateCreated;
  final String messageby;
  final String messageRole;
  final String text;
  final String attachment1;
  final String attachment2;
  final String attachment3;

  TicketMessages({
    this.dateCreated = '',
    this.messageby = '',
    this.messageRole = '',
    this.text = '',
    this.attachment1 = '',
    this.attachment2 = '',
    this.attachment3 = '',
  });

  factory TicketMessages.fromJson(Map<String, dynamic> json) {
    return TicketMessages(
      dateCreated: json['dateCreated'] ?? '',
      messageby: json['messageby'] ?? '',
      messageRole: json['messageRole'] ?? '',
      text: json['text'] ?? '',
      attachment1: json['attachment1'] ?? '',
      attachment2: json['attachment2'] ?? '',
      attachment3: json['attachment3'] ?? '',
    );
  }
}

class TicketTransaction {
  final double amount;
  final String type;

  TicketTransaction({this.amount = 0, this.type = ''});

  factory TicketTransaction.fromJson(dynamic json) {
    return TicketTransaction(
      amount: json['amount'] ?? 0.0,
      type: json['type'] ?? '',
    );
  }
}

class TicketDetailsModel {
  final TicketTransaction? transaction;
  final List<TicketMessages> messages;
  final String ticketStatus;
  final String uniqueId;
  final String subject;
  final String department;
  final String dateCreated;

  TicketDetailsModel({
    this.transaction,
    this.messages = const [],
    this.ticketStatus = '',
    this.uniqueId = '',
    this.subject = '',
    this.department = '',
    this.dateCreated = '',
  });

  factory TicketDetailsModel.fromJson(dynamic json) {
    return TicketDetailsModel(
      transaction: json['transaction'] != null
          ? TicketTransaction.fromJson(json['transaction'])
          : null,
      messages: (json['messages'] as List)
          .map((item) => TicketMessages.fromJson(item))
          .toList(),
      ticketStatus: json['ticketStatus'] ?? '',
      uniqueId: json['uniqueId'] ?? '',
      subject: json['subject'] ?? '',
      department: json['department'] ?? '',
      dateCreated: json['dateCreated'] ?? '',
    );
  }
}

class TicketItemModel {
  final int id;
  final String? tranRef;
  final String subject;
  final String ticketStatus;
  final String uniqueId;

  TicketItemModel({
    this.id = 0,
    this.tranRef,
    this.subject = '',
    this.ticketStatus = '',
    this.uniqueId = '',
  });

  factory TicketItemModel.fromJson(dynamic json) {
    return TicketItemModel(
      id: json['id'] ?? 0,
      tranRef: json['tranRef'],
      subject: json['subject'] ?? '',
      ticketStatus: json['ticketStatus'] ?? '',
      uniqueId: json['uniqueId'] ?? '',
    );
  }
}
