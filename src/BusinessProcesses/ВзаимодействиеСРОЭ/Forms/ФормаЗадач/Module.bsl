
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Для нового объекта выполняем код инициализации формы в ПриСозданииНаСервере.
	// Для существующего - в ПриЧтенииНаСервере.
	Если Объект.Ссылка.Пустая() Тогда
		ИнициализацияФормы();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	АвторСтрокой = Строка(Объект.Автор);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ТаблицаПредметовСнабжения, "Ссылка", Объект.БизнесПроцесс, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ИнициализацияФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	БизнесПроцессыИЗадачиКлиент.ФормаЗадачиОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияОткрытьФормуЗадачиНажатие(Элемент)
	
	ПоказатьЗначение(,Объект.Ссылка);
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(,Объект.Предмет);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаИсполненияПриИзменении(Элемент)
	
	Если Объект.ДатаИсполнения = НачалоДня(Объект.ДатаИсполнения) Тогда
		Объект.ДатаИсполнения = КонецДня(Объект.ДатаИсполнения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Функция ЭтоТочкаМарштрутаОжиданиеПолученияОтвета()
	
	Возврат Объект.ТочкаМаршрута = БизнесПроцессы.ВзаимодействиеСРОЭ.ТочкиМаршрута.ОжиданиеПолученияОтвета;
	
КонецФункции

&НаКлиенте
Процедура ВыполненаВыполнить(Команда)

	Объект.ВариантВыбораДляЗагрузки = 1;

	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтотОбъект, Истина);

КонецПроцедуры

&НаКлиенте
Процедура Дополнительно(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ОткрытьДопИнформациюОЗадаче(Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Функция ПодключитсяКЭксель(ИмяФайла)
	
	XLSОбъект = Новый COMОбъект("Excel.Application"); 
	
    Попытка
        Эксель = XLSОбъект.Workbooks.Open(ИмяФайла, , Истина);
    Исключение
		Инф = ИнформацияОбОшибке();
		Сообщить ("Проблемы с подключением к Excel: " + Инф.Причина.Описание);
		Возврат Неопределено;
    КонецПопытки;
	
	Возврат Эксель; 
	
КонецФункции

&НаСервере
Функция ОбновитьДанныеБизнецПроцесса()
	
	Результат = Новый Структура("Выполнено, Описание", Истина, "");
	
	БизнесПроцессОбъект = Объект.БизнесПроцесс.ПолучитьОбъект();
	
	ТаблЧасть = БизнесПроцессОбъект.ПредметыСнабжения;
	
	Для каждого Стр Из ТаблицаЗагрузки Цикл
		
		Если СокрЛП(Стр.N_STROKI) = "" Тогда
			ТекСтрока = Неопределено;
		Иначе
			ТекСтрока = ТаблЧасть.Найти(Число(Стр.N_STROKI), "НомерСтроки");
		КонецЕсли; 
		
		Если НЕ ТекСтрока = Неопределено Тогда
			
			ЗаполнитьЗначенияСвойств(ТекСтрока, Стр);
			
		КонецЕсли; 
		
	КонецЦикла; 
	
	Попытка
		БизнесПроцессОбъект.Записать();
		Результат.Выполнено = Истина;
	Исключение
	    ОписаниеОшибки = ОписаниеОшибки();
		Результат.Выполнено = Ложь;
		Результат.Описание = ОписаниеОшибки;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции
 
&НаКлиенте
Функция ЗагрузитьФайлИОбновитьТЧ()
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	Фильтр = "Табличный документ(*.xls);Табличный документ(*.xlsx)|*.xls;*.xlsx";
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = "Выберите файл";
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		ИмяФайла = ДиалогОткрытияФайла.ПолноеИмяФайла;
	КонецЕсли;
	
	Если ИмяФайла = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли; 
	
	Состояние("Начало загрузки",0, "Загрузка из файла");
	
	Эксель = ПодключитсяКЭксель(ИмяФайла);
	
	ТаблицаЗагрузки.Очистить();
	
	ЛистЭксель = Эксель.WorkSheets(1); 
	
	ВсегоСтрок = ЛистЭксель.Cells.SpecialCells(11).Row; 
	ВсегоКолонок = ЛистЭксель.Cells.SpecialCells(11).Column;
	
	Для сч = 2 По ВсегоСтрок Цикл // Самую первую пропускаем
		
		Если СокрЛП(ЛистЭксель.Cells(сч,  1).value) = "" Тогда
			Продолжить;
		КонецЕсли; 
		
		НовСтр = ТаблицаЗагрузки.Добавить();
		
		НовСтр.NSN 					= СокрЛП(ЛистЭксель.Cells(сч,  1).value);
		НовСтр.RN 					= СокрЛП(ЛистЭксель.Cells(сч,  2).value);
		НовСтр.RN_TRANSLIT 			= СокрЛП(ЛистЭксель.Cells(сч,  3).value);
		НовСтр.ORIG_NAME_RU 		= СокрЛП(ЛистЭксель.Cells(сч,  4).value);
		НовСтр.ORIG_NAME_ENG 		= СокрЛП(ЛистЭксель.Cells(сч,  5).value);
		НовСтр.ORIG_NAME_TRANSLIT 	= СокрЛП(ЛистЭксель.Cells(сч,  6).value);
		НовСтр.INC					= СокрЛП(ЛистЭксель.Cells(сч,  7).value);
		НовСтр.NAME_EN				= СокрЛП(ЛистЭксель.Cells(сч,  8).value);
		НовСтр.NAME_RU 				= СокрЛП(ЛистЭксель.Cells(сч,  9).value);
		НовСтр.NSG 					= СокрЛП(ЛистЭксель.Cells(сч, 10).value);
		НовСтр.NSC 					= СокрЛП(ЛистЭксель.Cells(сч, 11).value);
		НовСтр.NCAGE 				= СокрЛП(ЛистЭксель.Cells(сч, 12).value);
		НовСтр.CODIFIED_BY 			= СокрЛП(ЛистЭксель.Cells(сч, 13).value);
		НовСтр.NAME_ORG 			= СокрЛП(ЛистЭксель.Cells(сч, 14).value);
		НовСтр.NAME_ORG_TRANSLIT 	= СокрЛП(ЛистЭксель.Cells(сч, 15).value);
		НовСтр.CIN 					= СокрЛП(ЛистЭксель.Cells(сч, 16).value);
		НовСтр.DATE_CREA 			= СокрЛП(ЛистЭксель.Cells(сч, 17).value);
		НовСтр.DATE_ASSI 			= СокрЛП(ЛистЭксель.Cells(сч, 18).value);
		НовСтр.DATE_CANC 			= СокрЛП(ЛистЭксель.Cells(сч, 19).value);
		НовСтр.TIIC 				= СокрЛП(ЛистЭксель.Cells(сч, 20).value);
		НовСтр.RPDMRC 				= СокрЛП(ЛистЭксель.Cells(сч, 21).value);
		НовСтр.KIDN 				= СокрЛП(ЛистЭксель.Cells(сч, 22).value);
		НовСтр.RNCC 				= СокрЛП(ЛистЭксель.Cells(сч, 23).value);
		НовСтр.RNVC 				= СокрЛП(ЛистЭксель.Cells(сч, 24).value);
		НовСтр.DAC 					= СокрЛП(ЛистЭксель.Cells(сч, 25).value);
		НовСтр.RNJC 				= СокрЛП(ЛистЭксель.Cells(сч, 26).value);
		НовСтр.RNSC 				= СокрЛП(ЛистЭксель.Cells(сч, 27).value);
		НовСтр.RNFC 				= СокрЛП(ЛистЭксель.Cells(сч, 28).value);
		НовСтр.RNAAC 				= СокрЛП(ЛистЭксель.Cells(сч, 29).value);
		НовСтр.N_STROKI 			= СокрЛП(ЛистЭксель.Cells(сч, 30).value);
		
		Состояние("Идет загрузка", сч-1, "Загрузка из файла");
		
	КонецЦикла;
	
	Результат = ОбновитьДанныеБизнецПроцесса();
	
	Если Результат.Выполнено Тогда
		
		АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ИмяФайла));

		ДобавитьФайлВПрисоединенныеФайлы(ИмяФайла, АдресВоВременномХранилище);
		
		Состояние("Загрузка завершена", 100,"Загрузка из файла");
		
	Иначе
		
		Объект.РезультатВыполнения = Объект.РезультатВыполнения + Символы.ПС + Формат(ТекущаяДата(), "ДФ=dd.MM.yyyy") + " Ошибка: " + Результат.Описание;
		
	КонецЕсли; 
	
	Возврат Истина;
	
КонецФункции

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьФайлВПрисоединенныеФайлы(ПутьКФайлу, АдресВоВременномХранилище)
	
	ПолныйФайл= ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ПутьКФайлу);
	ИмяБезРасширения   = ПолныйФайл.ИмяБезРасширения;
	РасширениеБезТочки = СтрЗаменить(ПолныйФайл.Расширение, ".", "");
	
	ПараметрыФайла = Новый Структура;
	ПараметрыФайла.Вставить("ВладелецФайлов",              Объект.БизнесПроцесс);
	ПараметрыФайла.Вставить("Автор",                       ПараметрыСеанса.ТекущийПользователь);
	ПараметрыФайла.Вставить("ИмяБезРасширения",            ИмяБезРасширения);
	ПараметрыФайла.Вставить("РасширениеБезТочки",          РасширениеБезТочки);
	ПараметрыФайла.Вставить("ВремяИзменения",              Неопределено);
	ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", Неопределено);
	
	ПрисоединенныеФайлы.ДобавитьПрисоединенныйФайл(ПараметрыФайла, АдресВоВременномХранилище, "", "");
	
КонецПроцедуры

&НаСервере
Процедура ИнициализацияФормы()
	
	Если ЗначениеЗаполнено(Объект.БизнесПроцесс) Тогда
		ПараметрыФормы = БизнесПроцессыИЗадачиВызовСервера.ФормаВыполненияЗадачи(Объект.Ссылка);
		ЕстьФормаЗадачи = ПараметрыФормы.Свойство("ИмяФормы");
		//Элементы.ГруппаФормаВыполнения.Видимость = ЕстьФормаЗадачи;
		Элементы.Выполнена.Доступность = НЕ ЕстьФормаЗадачи;
	//Иначе
	//	Элементы.ГруппаФормаВыполнения.Видимость = Ложь;
	КонецЕсли;
	НачальныйПризнакВыполнения = Объект.Выполнена;
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Важность = Перечисления.ВариантыВажностиЗадачи.Обычная;
		Объект.СрокИсполнения = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Элементы.Предмет.Гиперссылка = Объект.Предмет <> Неопределено И НЕ Объект.Предмет.Пустая();
	ПредметСтрокой = ОбщегоНазначения.ПредметСтрокой(Объект.Предмет);	
	
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокНачалаИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.ДатаИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	БизнесПроцессыИЗадачиСервер.УстановитьФорматДаты(Элементы.СрокИсполнения);
	БизнесПроцессыИЗадачиСервер.УстановитьФорматДаты(Элементы.Дата);
	
	БизнесПроцессыИЗадачиСервер.ФормаЗадачиПриСозданииНаСервере(ЭтотОбъект, Объект, 
		Элементы.ГруппаСостояние, Элементы.ДатаИсполнения);
		
	Если ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
		Элементы.Автор.Видимость = Ложь;
		Элементы.АвторСтрокой.Видимость = Истина;
		Элементы.Исполнитель.КнопкаОткрытия = Ложь;
	КонецЕсли;
	
	Элементы.Выполнена.Доступность = ПравоДоступа("Изменение", Метаданные.Задачи.ЗадачаИсполнителя);
	
	// + 16.01.2018 10:58:37 Базунов Д.А. Задача: 

	Если НЕ Объект.Описание = "" Тогда
		Элементы.Описание.Видимость = Истина;
	Иначе
		Элементы.Описание.Видимость = Ложь;
	КонецЕсли; 
	
	Если Объект.РольИсполнителя.Пустая() Тогда
		Элементы.РольИсполнителя.Видимость = Ложь;
		Элементы.Исполнитель.Видимость = Истина;
	Иначе
		Элементы.РольИсполнителя.Видимость = Истина;
		Элементы.Исполнитель.Видимость = Ложь;
	КонецЕсли;
	
	ТочкиМаршрута = БизнесПроцессы.ВзаимодействиеСРОЭ.ТочкиМаршрута;
	
	Если Объект.ТочкаМаршрута = ТочкиМаршрута.ОжиданиеПолученияОтвета Тогда
		Элементы.ТаблицаПредметовСнабжения.ТолькоПросмотр = Истина;
		Элементы.ГруппаВариантыВыбора.Видимость = Истина;
		Элементы.Отклонить.Видимость = Истина;
	ИначеЕсли Объект.ТочкаМаршрута = ТочкиМаршрута.ОбновлениеДанныхВКаталогеПС Тогда
		ТолькоПросмотр = Истина;
		Элементы.ГруппаВариантыВыбора.Видимость = Ложь;
	КонецЕсли; 
	
	Если Объект.Выполнена Тогда
		Элементы.Выполнена.Доступность = Ложь;
		Элементы.ДатаИсполнения.Доступность = Ложь;
		Элементы.ДатаИсполненияВремя.Доступность = Ложь;
		Элементы.ГруппаВариантыВыбора.Доступность = Ложь;
		Элементы.Отклонить.Доступность = Ложь;
	КонецЕсли;
	
	// - 16.01.2018 10:58:37 Базунов Д.А. Задача: 
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПредметовСнабженияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(, Элемент.ТекущиеДанные.ПредметСнабжения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если СокрЛП(Объект.РезультатВыполнения) = "" Тогда
		Если Объект.ВыбранныйВариант = "" Тогда
			Объект.РезультатВыполнения = "Выполнена";
		Иначе
			Объект.РезультатВыполнения = СокрЛП(Объект.ВыбранныйВариант);
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайла(Команда)
	
	ЗагрузитьФайлИОбновитьТЧ();
	
	Элементы.ТаблицаПредметовСнабжения.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура Отклонить(Команда)
	
	Объект.ВариантВыбораДляЗагрузки = 2;
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтотОбъект, Истина);	
	
КонецПроцедуры

#КонецОбласти
