const List<String> diasDaSemana = [
  'Segunda',
  'Terça',
  'Quarta',
  'Quinta',
  'Sexta',
  'Sábado',
  'Domingo',
];

String doisDigitos(int numero) => numero.toString().padLeft(2, '0');

// Remove o horário e mantém só o dia.
DateTime somenteData(DateTime data) {
  return DateTime(data.year, data.month, data.day);
}

bool mesmoDia(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

// dd/MM/aaaa
String formatarData(DateTime data) {
  return '${doisDigitos(data.day)}/${doisDigitos(data.month)}/${data.year}';
}

// dd/MM
String formatarDiaCurto(DateTime data) {
  return '${doisDigitos(data.day)}/${doisDigitos(data.month)}';
}

// HH:mm
String formatarHora(DateTime data) {
  return '${doisDigitos(data.hour)}:${doisDigitos(data.minute)}';
}

// Hoje, Amanhã ou o dia da semana, seguido de dd/MM.
String formatarCabecalhoDoDia(DateTime dia, DateTime hoje) {
  final diferenca = somenteData(dia).difference(somenteData(hoje)).inDays;

  final String nome;

  if (diferenca == 0) {
    nome = 'Hoje';
  } else if (diferenca == 1) {
    nome = 'Amanhã';
  } else {
    nome = diasDaSemana[dia.weekday - 1];
  }

  return '$nome, ${formatarDiaCurto(dia)}';
}