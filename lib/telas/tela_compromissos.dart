import 'package:device_calendar/device_calendar.dart';
import 'package:exercicio_7/utils/formatar_data.dart';
import 'package:exercicio_7/widgets/cartao_compromisso.dart';
import 'package:flutter/material.dart';

class TelaCompromissos extends StatefulWidget {
  const TelaCompromissos({super.key});

  @override
  State<TelaCompromissos> createState() => _TelaCompromissosState();
}

class _TelaCompromissosState extends State<TelaCompromissos> {
  final DeviceCalendarPlugin _plugin = DeviceCalendarPlugin();

  List<Compromisso> _compromissos = [];
  DateTime _inicioPeriodo = somenteData(DateTime.now());

  bool _carregando = false;

  String _mensagem =
      'Pressione o botão para consultar os compromissos dos próximos 7 dias.';
  String _iconeMensagem = 'calendario';

  // O Android guarda a cor do calendário como um número inteiro.
  Color _corDoCalendario(int? cor) {
    if (cor == null) return const Color(0xFF2A49EB);

    return Color((cor & 0xFFFFFF) | 0xFF000000);
  }

  Compromisso? _converterEvento(Event evento, Calendar calendario) {
    final inicioEvento = evento.start;

    if (inicioEvento == null) return null;

    final fimEvento = evento.end ?? inicioEvento;
    final diaInteiro = evento.allDay ?? false;

    final DateTime inicio;
    DateTime fim;

    if (diaInteiro) {
      // O Android grava eventos de dia inteiro em UTC.
      final inicioUtc = DateTime.fromMillisecondsSinceEpoch(
        inicioEvento.millisecondsSinceEpoch,
        isUtc: true,
      );
      final fimUtc = DateTime.fromMillisecondsSinceEpoch(
        fimEvento.millisecondsSinceEpoch,
        isUtc: true,
      );

      inicio = DateTime(inicioUtc.year, inicioUtc.month, inicioUtc.day);
      fim = DateTime(fimUtc.year, fimUtc.month, fimUtc.day);

      if (!fim.isAfter(inicio)) {
        fim = inicio.add(const Duration(days: 1));
      }
    } else {
      inicio = DateTime.fromMillisecondsSinceEpoch(
        inicioEvento.millisecondsSinceEpoch,
      );
      fim = DateTime.fromMillisecondsSinceEpoch(
        fimEvento.millisecondsSinceEpoch,
      );
    }

    final titulo = evento.title?.trim() ?? '';

    return Compromisso(
      titulo: titulo.isEmpty ? 'Sem título' : titulo,
      calendario: calendario.name ?? 'Calendário',
      cor: _corDoCalendario(calendario.color),
      inicio: inicio,
      fim: fim,
      diaInteiro: diaInteiro,
      local: evento.location?.trim() ?? '',
      descricao: evento.description?.trim() ?? '',
    );
  }

  // Compromissos que começaram antes de hoje aparecem no grupo de hoje.
  DateTime _diaDoGrupo(Compromisso compromisso) {
    final dia = somenteData(compromisso.inicio);

    return dia.isBefore(_inicioPeriodo) ? _inicioPeriodo : dia;
  }

  int _compararCompromissos(Compromisso a, Compromisso b) {
    final porDia = _diaDoGrupo(a).compareTo(_diaDoGrupo(b));

    if (porDia != 0) return porDia;

    if (a.diaInteiro != b.diaInteiro) {
      return a.diaInteiro ? -1 : 1;
    }

    return a.inicio.compareTo(b.inicio);
  }

  void _mostrarErro() {
    setState(() {
      _mensagem = 'Não foi possível consultar os compromissos. Tente novamente.';
      _iconeMensagem = 'erro';
    });
  }

  Future<void> _consultarCompromissos() async {
    if (_carregando) return;

    final inicioPeriodo = somenteData(DateTime.now());
    final fimPeriodo = inicioPeriodo.add(const Duration(days: 7));

    setState(() {
      _carregando = true;
      _compromissos = [];
      _inicioPeriodo = inicioPeriodo;
      _mensagem = 'Verificando acesso ao calendário...';
    });

    try {
      var permissao = await _plugin.hasPermissions();

      if (!mounted) return;

      if (permissao.isSuccess && permissao.data != true) {
        permissao = await _plugin.requestPermissions();

        if (!mounted) return;
      }

      if (!permissao.isSuccess) {
        _mostrarErro();
        return;
      }

      if (permissao.data != true) {
        setState(() {
          _mensagem =
              'O acesso ao calendário não foi autorizado. Libere a permissão '
              'nas configurações do aparelho e tente novamente.';
          _iconeMensagem = 'bloqueado';
        });

        return;
      }

      setState(() {
        _mensagem = 'Consultando compromissos...';
      });

      final calendarios = await _plugin.retrieveCalendars();

      if (!mounted) return;

      final listaCalendarios = calendarios.data;

      if (!calendarios.isSuccess || listaCalendarios == null) {
        _mostrarErro();
        return;
      }

      final encontrados = <Compromisso>[];

      for (final calendario in listaCalendarios) {
        final id = calendario.id;

        if (id == null) continue;

        final eventos = await _plugin.retrieveEvents(
          id,
          RetrieveEventsParams(startDate: inicioPeriodo, endDate: fimPeriodo),
        );

        if (!mounted) return;

        final listaEventos = eventos.data;

        if (!eventos.isSuccess || listaEventos == null) {
          _mostrarErro();
          return;
        }

        for (final evento in listaEventos) {
          final compromisso = _converterEvento(evento, calendario);

          if (compromisso == null) continue;

          final dentroDoPeriodo = compromisso.fim.isAfter(inicioPeriodo) &&
              compromisso.inicio.isBefore(fimPeriodo);

          if (dentroDoPeriodo) {
            encontrados.add(compromisso);
          }
        }
      }

      encontrados.sort(_compararCompromissos);

      setState(() {
        _compromissos = encontrados;

        if (encontrados.isEmpty) {
          _mensagem = 'Nenhum compromisso nos próximos 7 dias.';
          _iconeMensagem = 'vazio';
        } else {
          _mensagem = '${encontrados.length} compromisso(s) encontrado(s).';
          _iconeMensagem = 'calendario';
        }
      });
    } catch (_) {
      if (!mounted) return;

      _mostrarErro();
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  Widget _construirConteudo() {
    if (_carregando) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(_mensagem, textAlign: TextAlign.center),
          ],
        ),
      );
    }

    if (_compromissos.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/icones/$_iconeMensagem.png',
                width: 72,
                height: 72,
              ),
              const SizedBox(height: 16),
              Text(
                _mensagem,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _mensagem,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: _compromissos.length,
            itemBuilder: (context, indice) {
              final compromisso = _compromissos[indice];
              final dia = _diaDoGrupo(compromisso);
              final novoDia = indice == 0 ||
                  !mesmoDia(dia, _diaDoGrupo(_compromissos[indice - 1]));

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (novoDia)
                    Padding(
                      padding: EdgeInsets.only(
                        top: indice == 0 ? 0 : 12,
                        bottom: 8,
                      ),
                      child: Text(
                        formatarCabecalhoDoDia(dia, _inicioPeriodo),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2A49EB),
                        ),
                      ),
                    ),
                  CartaoCompromisso(compromisso: compromisso),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ultimoDia = _inicioPeriodo.add(const Duration(days: 6));

    return Scaffold(
      appBar: AppBar(title: const Text('Compromissos')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/icones/calendario.png',
                  width: 32,
                  height: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Próximos 7 dias',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${formatarData(_inicioPeriodo)} a '
                        '${formatarData(ultimoDia)}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _carregando ? null : _consultarCompromissos,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/icones/consultar.png',
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text('Consultar compromissos'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: _construirConteudo()),
          ],
        ),
      ),
    );
  }
}