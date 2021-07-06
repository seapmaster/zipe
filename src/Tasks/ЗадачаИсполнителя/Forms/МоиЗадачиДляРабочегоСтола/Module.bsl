
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	БизнесПроцессыИЗадачиСервер.УстановитьПараметрыСпискаМоихЗадач(Список);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Выполнена", Ложь);
			
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокИсполнения.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	Элементы.ДатаНачала.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	Элементы.Дата.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	
	// Установка отбора динамического списка.
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "ПометкаУдаления", Ложь, ВидСравненияКомпоновкиДанных.Равно, , ,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный);
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	СгруппироватьПоКолонкеНаСервере(Настройки["РежимГруппировки"]);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_ЗадачаИсполнителя" Тогда
		ОбновитьСписокЗадачНаСервере();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	БизнесПроцессыИЗадачиКлиент.СписокЗадачПередНачаломДобавления(ЭтотОбъект, Элемент, Отказ, Копирование, 
		Родитель, Группа);
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	Если Элемент.ТекущиеДанные <> Неопределено
		И Элемент.ТекущиеДанные.Свойство("ПринятаКИсполнению")
		И НЕ Элемент.ТекущиеДанные.ПринятаКИсполнению Тогда
			Элементы.ПринятьКИсполнению.Доступность= Истина;
	Иначе
		Элементы.ПринятьКИсполнению.Доступность= Ложь;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьБизнесПроцесс(Команда)
	БизнесПроцессыИЗадачиКлиент.ОткрытьБизнесПроцесс(Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПредметЗадачи(Команда)
	БизнесПроцессыИЗадачиКлиент.ОткрытьПредметЗадачи(Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоВажности(Команда)
	СгруппироватьПоКолонке("Важность");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоБезГруппировки(Команда)
	СгруппироватьПоКолонке("");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоТочкеМаршрута(Команда)
	СгруппироватьПоКолонке("ТочкаМаршрута");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоАвтору(Команда)
	СгруппироватьПоКолонке("Автор");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоПредмету(Команда)
	СгруппироватьПоКолонке("ПредметСтрокой");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоСроку(Команда)
	СгруппироватьПоКолонке("СрокДляГруппировки");
КонецПроцедуры

&НаКлиенте
Процедура ПринятьКИсполнению(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ПринятьЗадачиКИсполнению(Элементы.Список.ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПринятиеКИсполнению(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ОтменитьПринятиеЗадачКИсполнению(Элементы.Список.ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокЗадач(Команда)
	
	ОбновитьСписокЗадачНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	// Скрыть вторую строку группировки.
	КолонкиСпискаЗадач = Новый Массив();
	ВыбратьВсеПодчиненныеЭлементы(Элементы.ГруппаКолонки, КолонкиСпискаЗадач);
	Для каждого ЭлементФормы Из КолонкиСпискаЗадач Цикл
		
		Если ЭлементФормы = Элементы.Наименование Тогда
			Продолжить;
		КонецЕсли;
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементФормы.Имя);
		
	КонецЦикла;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Ссылка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	БизнесПроцессыИЗадачиСервер.УстановитьОформлениеЗадач(Список);
	
КонецПроцедуры

&НаСервере
Процедура ВыбратьВсеПодчиненныеЭлементы(Родитель, Результат)
	
	Для каждого ЭлементФормы Из Родитель.ПодчиненныеЭлементы Цикл
		
		Результат.Добавить(ЭлементФормы);
		Если ТипЗнч(ЭлементФормы) = Тип("ГруппаФормы") Тогда
			ВыбратьВсеПодчиненныеЭлементы(ЭлементФормы, Результат); 
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоКолонке(Знач ИмяКолонкиРеквизита)
	РежимГруппировки = ИмяКолонкиРеквизита;
	Список.Группировка.Элементы.Очистить();
	Если НЕ ПустаяСтрока(ИмяКолонкиРеквизита) Тогда
		ПолеГруппировки = Список.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных(ИмяКолонкиРеквизита);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СгруппироватьПоКолонкеНаСервере(Знач ИмяКолонкиРеквизита)
	РежимГруппировки = ИмяКолонкиРеквизита;
	Список.Группировка.Элементы.Очистить();
	Если НЕ ПустаяСтрока(ИмяКолонкиРеквизита) Тогда
		ПолеГруппировки = Список.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных(ИмяКолонкиРеквизита);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокЗадачНаСервере()
	
	БизнесПроцессыИЗадачиСервер.УстановитьПараметрыСпискаМоихЗадач(Список);
	// Цвет просроченных задач зависит от значения текущей даты,
	// поэтому нужно переинициализировать условное оформление.
	УстановитьУсловноеОформление();
	Элементы.Список.Обновить();
	
КонецПроцедуры

//++ 09.04.2018 Веденеев П. //поиск и открытие задачи по импорту данных от поставщика

&НаКлиенте
Процедура НайтиПоИмениФайла(Команда)
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	ДиалогОткрытияФайла.Фильтр = "Документ MS Excel 2010 (*.xlsx)|*.xlsx|Документ MS Excel(*.xls)|*.xls";
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = "Выберите файл поставщика:";
	
	ДиалогОткрытияФайла.Показать(Новый ОписаниеОповещения("НайтиПоИмениФайлаЗавершение", ЭтотОбъект, Новый Структура("ДиалогОткрытияФайла", ДиалогОткрытияФайла)));
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиПоИмениФайлаЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	ДиалогОткрытияФайла = ДополнительныеПараметры.ДиалогОткрытияФайла;
	Если (ВыбранныеФайлы <> Неопределено) Тогда
		Файл = Новый Файл(ДиалогОткрытияФайла.ПолноеИмяФайла);
		Расширение = СтрЗаменить(Файл.Расширение, ".", "");
		Задача = ПолучитьЗадачуПоИмпорту(Файл.ИмяБезРасширения, Расширение);
		Если Задача = Неопределено Тогда
			Сообщить("Не обнаружено задач по данному файлу!");
			Возврат;
		КонецЕсли;
		ОткрытьФорму("БизнесПроцесс.ЗапросНаАктуализациюКаталогаПоставщика.Форма.ФормаЗадач", Новый Структура("Ссылка", Задача));
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЗадачуПоИмпорту(ИмяФайла, Расширение)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗадачаИсполнителя.Ссылка КАК Задача,
	|	ЗадачаИсполнителя.Дата КАК Дата
	|ПОМЕСТИТЬ втЗадачи
	|ИЗ
	|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
	|ГДЕ
	|	ЗадачаИсполнителя.БизнесПроцесс В
	|			(ВЫБРАТЬ
	|				ЗапросНаАктуализациюКаталогаПоставщика.Ссылка КАК Ссылка
	|			ИЗ
	|				БизнесПроцесс.ЗапросНаАктуализациюКаталогаПоставщика КАК ЗапросНаАктуализациюКаталогаПоставщика
	|			ГДЕ
	|				ЗапросНаАктуализациюКаталогаПоставщика.Ссылка В
	|					(ВЫБРАТЬ
	|						ЗапросНаАктуализациюКаталогаПоставщикаПрисоединенныеФайлы.ВладелецФайла КАК БизнесПроцесс
	|					ИЗ
	|						Справочник.ЗапросНаАктуализациюКаталогаПоставщикаПрисоединенныеФайлы КАК ЗапросНаАктуализациюКаталогаПоставщикаПрисоединенныеФайлы
	|					ГДЕ
	|						ЗапросНаАктуализациюКаталогаПоставщикаПрисоединенныеФайлы.Наименование = &ИмяФайла
	|						И ЗапросНаАктуализациюКаталогаПоставщикаПрисоединенныеФайлы.Расширение = &Расширение)
	|				И НЕ ЗапросНаАктуализациюКаталогаПоставщика.ПометкаУдаления
	|				И НЕ ЗапросНаАктуализациюКаталогаПоставщика.Завершен)
	|	И НЕ ЗадачаИсполнителя.ПометкаУдаления
	|	И ЗадачаИсполнителя.ТочкаМаршрута = &ТочкаМаршрута
	|	И ЗадачаИсполнителя.Автор = &Автор
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Дата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(втЗадачи.Дата) КАК Дата
	|ПОМЕСТИТЬ втМасимальнаяДата
	|ИЗ
	|	втЗадачи КАК втЗадачи
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Дата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втЗадачи.Задача КАК Задача
	|ИЗ
	|	втЗадачи КАК втЗадачи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втМасимальнаяДата КАК втМасимальнаяДата
	|		ПО втЗадачи.Дата = втМасимальнаяДата.Дата";
	Запрос.УстановитьПараметр("ИмяФайла", ИмяФайла);
	Запрос.УстановитьПараметр("Расширение", Расширение);
	Запрос.УстановитьПараметр("ТочкаМаршрута", БизнесПроцессы.ЗапросНаАктуализациюКаталогаПоставщика.ТочкиМаршрута.ОжиданиеПолученияОтвета);
	Запрос.УстановитьПараметр("Автор", ПараметрыСеанса.ТекущийПользователь);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Задача;
	
КонецФункции

//-- 09.04.2018 Веденеев П. //поиск и открытие задачи по импорту данных от поставщика

#КонецОбласти
