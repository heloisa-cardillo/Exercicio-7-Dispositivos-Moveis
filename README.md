# Exercício 7 - Consulta aos compromissos do calendário

Exercício da disciplina Programação para Dispositivos Móveis (Prof. Arley - FATEC), da Aula 7, sobre permissões e acesso a recursos do dispositivo.

O app consulta o calendário do celular e lista os compromissos de hoje e dos próximos seis dias, num total de sete dias.

<details>
<summary><strong>Funcionalidades</strong></summary>

- Pede permissão de acesso ao calendário.
- O botão "Consultar compromissos" busca os eventos de todos os calendários do aparelho.
- Lista os compromissos em ordem cronológica, agrupados por dia ("Hoje", "Amanhã", dia da semana).
- Mostra, em cada compromisso, título, calendário, data e horário de início e fim, local e descrição.
- Identifica os compromissos de dia inteiro com uma etiqueta.
- Mostra um indicador de carregamento durante a consulta.
- Avisa quando não há compromissos, quando o acesso é negado e quando a consulta falha.

</details>

<details>
<summary><strong>Permissões</strong></summary>

Declaradas em `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.READ_CALENDAR" />
<uses-permission android:name="android.permission.WRITE_CALENDAR" />
```

O app só lê o calendário. A permissão de escrita também é declarada porque o pacote `device_calendar` solicita as duas juntas.

</details>

<details>
<summary><strong>Recursos utilizados</strong></summary>

- Pacote `device_calendar` para acessar os calendários e os eventos do aparelho
- `hasPermissions` e `requestPermissions` para verificar e pedir a permissão
- `retrieveCalendars` e `retrieveEvents` para buscar os calendários e os compromissos do período
- `async`/`await`, `try`/`catch`/`finally` e `mounted` para tratar as operações assíncronas
- `StatefulWidget` e `setState` para atualizar a tela conforme o resultado
- `ListView.builder` para montar a lista
- `ThemeData` com cores, botões e cards personalizados
- Ícones próprios em PNG em `assets/icones`

</details>

<details>
<summary><strong>Estrutura</strong></summary>

```
Exercicio-7-Dispositivos-Moveis/
├── android/
│   └── app/src/main/AndroidManifest.xml
├── assets/
│   ├── icones/
│   └── midia/
│       └── Video Demostrativo Ex 7.gif
├── lib/
│   ├── main.dart
│   ├── telas/
│   │   └── tela_compromissos.dart
│   ├── widgets/
│   │   └── cartao_compromisso.dart
│   └── utils/
│       └── formatar_data.dart
└── pubspec.yaml
```

</details>

<details>
<summary><strong>Como executar</strong></summary>

O app funciona só no Android, num emulador ou num celular com a depuração USB ativada.

```
flutter pub get
flutter run
```

</details>

<br> 

![Demonstração do app](assets/midia/Video%20Demostrativo%20Ex%207.gif)