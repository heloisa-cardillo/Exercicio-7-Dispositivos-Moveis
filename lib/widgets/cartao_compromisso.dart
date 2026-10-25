import 'package:exercicio_7/utils/formatar_data.dart';
import 'package:flutter/material.dart';

class Compromisso {
  final String titulo;
  final String calendario;
  final Color cor;
  final DateTime inicio;
  final DateTime fim;
  final bool diaInteiro;
  final String local;
  final String descricao;

  const Compromisso({
    required this.titulo,
    required this.calendario,
    required this.cor,
    required this.inicio,
    required this.fim,
    required this.diaInteiro,
    required this.local,
    required this.descricao,
  });
}

class CartaoCompromisso extends StatelessWidget {
  final Compromisso compromisso;

  const CartaoCompromisso({super.key, required this.compromisso});

  String textoHorario() {
    final inicio = compromisso.inicio;
    final fim = compromisso.fim;

    if (compromisso.diaInteiro) {
      // No calendário, o fim de um evento de dia inteiro é o dia seguinte.
      final ultimoDia = fim.subtract(const Duration(days: 1));

      if (!ultimoDia.isAfter(inicio)) {
        return 'Dia inteiro em ${formatarData(inicio)}';
      }

      return 'Dia inteiro de ${formatarData(inicio)} a ${formatarData(ultimoDia)}';
    }

    if (mesmoDia(inicio, fim)) {
      return '${formatarData(inicio)}, das ${formatarHora(inicio)} '
          'às ${formatarHora(fim)}';
    }

    return 'De ${formatarData(inicio)} ${formatarHora(inicio)} '
        'a ${formatarData(fim)} ${formatarHora(fim)}';
  }

  Widget linhaInformacao(String icone, String texto, {bool vazio = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/icones/$icone.png', width: 18, height: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              texto,
              style: TextStyle(
                fontSize: 13,
                color: vazio
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF374151),
                fontStyle: vazio ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final corPrincipal = Theme.of(context).colorScheme.primary;
    final semLocal = compromisso.local.isEmpty;
    final semDescricao = compromisso.descricao.isEmpty;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 6, color: compromisso.cor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: compromisso.diaInteiro
                            ? corPrincipal
                            : const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        compromisso.diaInteiro
                            ? 'Dia inteiro'
                            : '${formatarHora(compromisso.inicio)} – '
                                  '${formatarHora(compromisso.fim)}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: compromisso.diaInteiro
                              ? Colors.white
                              : corPrincipal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      compromisso.titulo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    linhaInformacao('calendario', compromisso.calendario),
                    linhaInformacao('relogio', textoHorario()),
                    linhaInformacao(
                      'local',
                      semLocal ? 'Sem local informado' : compromisso.local,
                      vazio: semLocal,
                    ),
                    linhaInformacao(
                      'descricao',
                      semDescricao ? 'Sem descrição' : compromisso.descricao,
                      vazio: semDescricao,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
