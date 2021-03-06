# RightJS 2 инструкция по миграции

Прежде чем двигаться далье, пожалуйста прочтите следующие две статьи. Они
дадут вам общее представление о всех изменениях которые несет RightJS 2

 * [Что нового в RightJS 2](/tutorials/what-new-in-rjs2)
 * [Что нового в RightJS UI 2](/tutorials/what-new-in-rui2)

По прочтению у вас должно сложиться общее представление что делать и как
мигрировать, но в дополнение двайте соберем все вместе в небольшой список



## 1. Обновить сборки, :builds

Перво на перво нужно обновить все сборки, скачайте новое ядро на странице
[закачек](/downloads) и возьмите новые билды [UI](/ui) и [плагинов](/plugins)
Так же не забудьте взять обновленные
[i18n модули](http://github.com/rightjs/rightjs-ui/tree/master/i18n/), в них
было так же несколько изменений.

Если вы используете [right-rails](http://github.com/MadRabbit/right-rails),
просто запустите стандартный `right_rails` генератор, он автоматически
заменит все старые файлы новыми



## 2. Проверить доступ к атрибутам, :args

Это наиболее болезненная часть миграции. Т.к. мы переключаемся с прямого
доступа к элементам страниц, на использование dom-оберток, вы больше не имеете
непосредственного доступа к атрибутам элементов и должны использовать методы
{Element#set} и {Element#get}.

    // старый
    element.id;
    //новый
    element.get('id');

    // старый
    element.id = 'my-id';
    // новый
    element.set('id', 'my-id');

Но вы можете тут схалтурить и обращаться напрямую к элементам через свойство
`_`, которое ссылается непосредственно на сам объект элемента страницы.

    element._.id;
    element._.id = 'my-id';

Это совершенно лигитимный способ, поэтому не смущайтесь, пользуйтесь. Для
работы со свойством `innerHTML` используйте новый метод {Element#html}, он
работает в обе стороны:

    element.html(); // -> возвращает innerHTML строку
    element.html('boo hoo!'); // устанавливает innerHTML

Так же было добавлено несколько прочих новый методов для класса {Element},
которые могут оказаться полезными, поэтому загляните в
[список новых методов](/tutorials/what-new-in-rjs2#new-dom-methods)


## 3. Проверить доступ к окнам и документам, :windoc

Если вам нужны расширения объектов `window` и `document`, вы можете получить
доступ к ним через стандартную функцию `$()`, точно так же как вы это делаете
для любых прочих элементов страницы:

    $(window).size();
    $(document).onReady();

Мы больше не расширяем никакие dom-элементы напрямую.


## 4. Делегация событий, :ujs

Поддержка UJS в RightJS 2 была обновлена и расширена. Суперудобный интерфейс
{String#on} остался на месте, но хак `Event.delegate` был убран в пользу
стандартного интерфейса для работы с делегацией событий. См. методы
{Element#delegate} и {Element#undelegate}.

Если вы пользовались интерфейсом `Event.delegate`, посмотрите новые методы,
они очень близки по семантике и упрощают многие вещи.


## 5. Устаревшие методы, :deprecations

Благодаря dom-оберткам, мы больше не имеем никаких ограничений на имена
методов, поэтому некоторые из них были переименованы для большего удобства.
Список изменений можно найти
[вот тут](/tutorials/what-new-in-rjs2#new-dom-methods).

Старые методы будут еще доступны некоторое время, поэтому это не обязательный
шаг и его можно при желании пока пропустить.


## 6. Изменения в UI модулях, :ui

UI модули, внутренне практически остались такими же как были, но произошло
несколько небольших изменений для того чтобы сделать виджеты более
единообразными и удобными в работе:

 1. Префикс имен css классов был изменен с `right-` на `rui-`. Новый вариант
    естественно звучит менее нагло, но зато имеет меньше шансов вызвать
    коллизии с пользовательскими стилями.

 2. Автоматическая инициализация виджетов была упорядочена и вместо набора
    различных специальных атрибутов и имен классов, все виджеты теперь
    используют единообразные HTML5 атрибуты вида `data-[имя-виджета]`

 3. Все виджеты теперь являются точно такими же элементами, как все прочие
    dom-объекты. Ввиду этого система обработки событий была немного изменена,
    вместо того чтобы скармливать слушателям различные наборы аргументов,
    виджеты теперь создают обычные dom-события и все данные доступны как
    атрибуты объектов событий.

Так же у разных виджетов, имели место быть различные мелкие фиксы и
исправления в структуре HTML/CSS, были немного изменены i18n модули, некоторые
виджеты получили новые опции, некоторые потеряли старые, кое где добавилась
новая функциональность и т.п.

Если вы плотно работаете с какими-либо виджетами, загляните на их страницы в
разделе [UI](/ui).

