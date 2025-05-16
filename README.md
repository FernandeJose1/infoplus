# InfoPlus

InfoPlus é um aplicativo móvel Flutter voltado para usuários moçambicanos que desejam consultar informações importantes locais, como vagas de emprego, preços de produtos essenciais e recompensas. O acesso às informações é controlado por um sistema de micro pagamentos via USSD (M-Pesa e e-Mola), garantindo monetização justa e adaptada ao contexto local.

---

## Funcionalidades Principais

- **Login por telefone** via Firebase Authentication.
- **Consulta de vagas de emprego** e preços com pagamento por consulta.
- **Pagamento via USSD**, automático para M-Pesa ou e-Mola, com PIN de confirmação.
- **Histórico de consultas gratuito** válido por 24 horas, permitindo revisão sem novos pagamentos.
- **Painel administrativo** para gerenciar vagas, preços e recompensas, acessível apenas para administradores.
- **Sincronização offline** com SQLite para futuras melhorias.

---

## Fluxo do Aplicativo

1. **Autenticação:** O usuário faz login com o número de telefone e recebe um código via SMS.
2. **Tela inicial:** Opções para consultar vagas, preços, recompensas, acessar o histórico, selecionar província ou registrar novo usuário.
3. **Consulta com pagamento:**  
   - Ao escolher vagas ou preços, o app inicia um pagamento via USSD.  
   - O usuário confirma o pagamento inserindo o PIN.  
   - Após pagamento, o conteúdo é liberado e a consulta é registrada.
4. **Histórico de consultas:**  
   - Usuários podem acessar gratuitamente as consultas feitas nas últimas 24h.
5. **Painel do administrador:**  
   - Acesso restrito para criar, editar e deletar vagas, preços e recompensas.

---

## Tecnologias Utilizadas

- **Flutter & Dart** para desenvolvimento multiplataforma (Android e iOS).
- **Firebase Authentication** para login seguro via telefone.
- **Cloud Firestore** para armazenamento de dados e histórico.
- **Firebase Cloud Functions** para lógica de validação de PIN e integração com USSD.
- **Provider** para gerenciamento de estado no app.
- **SQLite (Drift)** para cache e sincronização offline.
- **Integração nativa USSD** para pagamentos móveis locais (M-Pesa, e-Mola).

---

## Estrutura do Projeto

- **/lib/models:** Modelos de dados (`User`, `Job`, `Price`, `Reward`, `ConsultaHistorico`, etc).
- **/lib/providers:** Providers para gerenciamento de estado e lógica de negócio.
- **/lib/views:** Telas do aplicativo (Home, Login, Jobs, Prices, Rewards, Admin, Histórico, etc).
- **/lib/widgets:** Componentes reutilizáveis, formulários e controles.
- **/lib/services:** Serviços para comunicação com Firebase, sincronização e pagamento.
- **/lib/config:** Configurações e variáveis de ambiente.
- **/functions:** Código das Firebase Cloud Functions para backend.

---

## Como Rodar

1. Configure o Firebase para seu projeto, habilitando Authentication, Firestore e Functions.
2. Configure os arquivos de ambiente (`env.dart`) com suas credenciais.
3. Execute:
   ```bash
   flutter pub get
   flutter run

4. Teste o login, consultas e pagamentos usando números de telefone moçambicanos válidos.

Considerações Finais

Este projeto é uma solução adaptada às necessidades locais de Moçambique, com foco em inclusão digital e sustentabilidade financeira. O sistema de pagamento via USSD garante que mesmo usuários sem acesso constante à internet possam usar o app com facilidade.