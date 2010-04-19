# Unobtrusive программирование и делегация событий

Данная статья рассматривает вопросы написания ненавязчивых (unobtrusive)
скриптов с использованием техники делегации обработки событий

<%= anchors_index %>

## Что такое делегация событий?, :what

Делегация обработки событий это один из способов обработки DOM событий на
веб-страницах. Он использует эффект распространения (bubbling) событий по
дереву документа для того чтобы обрабатывать несколько элементов в одном
месте.

Для примера скажем у вас есть веб-страница со следующей структурой

    <html>
      <body>
        <ul id="todos">
          <li>Проснуться</li>
          <li>Побриться</li>
          <li>Покормить рыбок</li>
          <li>Захватить власть над миром</li>
        </ul>
      </body>
    </html>

Когда пользователь кликает на любом `LI` элементе, событие клика не 
останавливается на элементе списка, а продолжает распространяться по структуре
документа, передаваясь во элемент `UL`, затем в `BODY`, `HTML` и в конце
концов попадает в объект документа.

Обычно мы подключаем слушателей событий непосредственно к нужным элементам и
обрабатываем события локально. Но мы с тем же успехом можем слушать события
на любом уровне, и затем в зависимости от того какой именно элемент вызвал
то или иное событие, вызывать соответствующий обработчик.


## Зачем это делать?, :why

Есть несколько причин зачем вам может понадобиться обработка событий с
делегацией.

Во-первых вы можете иметь большое количество элементов. Например если у вас
есть таблица размером 50х50 клеток и вам нужно единообразно обрабатывать клики
на всех из них. Вместо того чтобы подключать слушателей ко всем 2500 ячейкам,
вы можете подключить один единственный слушатель на уровне элемента самой
таблицы, что может во много раз уменьшить время инициализации вашего 
приложения.

Второй типичный пример это динамический контент. Скажем вам нужно динамически
добавлять ячейки в таблицу из первого примера. Если вы подключаете слушателей
для каждой ячейки отдельно, то вместе с логикой создания новых ячеек вам нужно
будет позаботиться о соответствующей инициализации обработчиков событий, что
может серьезно усложнить программный код и замедлить приложение. В случае же
одного общего слушателя событий, все новые элементы будут обрабатываться
автоматически точно так же как и любые из тех что уже существуют в таблице.

Третье применение известно как "ненавязчивое (unobtrusive) 
программирование". Идея его в том, что можно описать всю логику приложения в 
одном месте на уровне документа, без непосредственного доступа и каких либо
изменений в самих элементах страницы. Это дает несколько преимуществ в дизайне
приложений, а так же позволяет создавать более или менее безопасные приложения
которые не влияют друг на друга.

Хорошим примером будут виджеты. Мы используем технику делегации событий во
многих виджетах из библиотеки RightJS UI, например Lightbox, Calendar,
Autocompleter и т.д. Это позволяет существенно сократить время инициализации
виджетов, дает им работать с динамическим контентом и инкапсулирует их логику
во всего нескольких обработчиках событий уровня документа.


## Простой пример, :example

Помните список задач из самого начала статьи? Предположим нам необходимо,
чтобы по клику на любом элементе списка, этот элемент переключал наличие
соответствующего css-класса. В случае RightJS код может выглядеть следующим
образом

    "#todos li".on('click', function() {
      this.toggleClass('marked');
    });

Этот простой кусок кода говорит документу следить за кликами и когда 
пользователь кликает на элементе из списка, то вызвать нашу функцию в 
контексте этого элемента.

На первый взгляд это может показаться немного странным, вызывать метод `on` на
строке,но если вы прочитаете сам код, то вы заметите, что он отлично читается.
Более того, метод `on` имеет точно тот же самый API что и метод {Element#on},
вы можете вызывать его с хэшами, списками и указывать обработчики по имени.

    "#todos li".on({
      click: function() {
        this.toggleClass('marked');
      }
    });
    
    // со списком обработчиков
    "#todos li".on('click', [
      function1, function2, function3
    ]);

    // с указанием обработчика по имени
    "#todos li".on('click', 'toggleClass', 'marked');

Вы можете думать об этом как о глобальном слушателе событий. Он делает все
тоже самое что и метод {Element#on}, только работает глобально на всех 
элементах которые подпадают под указанное правило.


## Продвинутые возможности, :deeper

Метод {String#on} это на самом деле сокращение для метода {Element#behave}.
Разница между ними в том, что последний возвращает объект с теми обработчиками
событий которые были подключены непосредственно на уровень документа. Это
позволяет отменить делегирование событий когда вам это потребуется. Например.

    var handlers = Event.behave("#todos li", "click", function() {
      this.toggleClass('marked');
    });
    
    // теперь мы можем отключить обработчик
    document.stopObserving(handlers);

Так же существует еще один метод называемый {Event#delegate} который создает
функции которые непосредственно делегируют обработку событий. Вы можете 
использовать этот метод для создания ваших собственных делегирующих 
обработчиков и подключать их на любой уровень где вам захочется.

Для примера. Скажем у вас есть таблица с двумя секциями `THEAD` и `TBODY`, и 
вам бы хотелось, чтобы по клику на ячейку в заголовке, скрипт подсвечивал 
колонку в таблице, а по клику на ячейку в теле таблице, он подсвечивал бы
соответствующий ряд. Вы можете сделать это следующим образом

    $('my-table').onClick(Event.delegate({
      'thead td': function() {
        // подсвечиваем колонку
      },
      
      'tbody td': function() {
        // подсвечиваем ряд
      }
    }));

В данном случае мы подключаем один единственный обработчик события `click`, но
он будет вызывать разные функции в зависимости от того, какая ячейка была
кликнута.


## Известные проблемы, :troubleshooting

Существует одна общая проблема с техникой делегации событий о которой вы 
должны знать.

Т.к. данная техника использует эффект распространения события по дереву 
документа, делегация обработки событий не будет работать, если событие было
остановлено где-то между источником и получателем. Например

    "#todos li".on("click", "toggleClass", "marked");
    
    $('todos').onClick(function(event) {
      event.stop();
    });

В данном случае, когда событие достигнет элемента `UL`, оно будет полностью
остановлено. Таким образом событие никогда не достигнет обработчика на уровне
документа и переключение класса не будет работать.

Если вы желаете отменить обработку события браузером по умолчанию, но при этом
хотите чтобы событие продолжало распространяться по документу, используйте
метод {Event#preventDefault} вместо {Event#stop}

