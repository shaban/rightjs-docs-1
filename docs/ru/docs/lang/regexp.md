# Регулярные выражения

### .escape

    RegExp.escape(String string) -> String new

Обрабатывает все командные символы в полученной строке делая ее пригодной для
использования в регулярном выражении

    RegExp.escape('[{!}]'); // -> "\[\{\!\}\]"
