
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	//++ 13.03.2018 Веденеев П. //отключение непосредственного изменения данных
	Если ПолучитьФункциональнуюОпцию("ИспользоватьБизнесПроцессыДляКорректировкиСправочников") И КоманднаяПанель.ПодчиненныеЭлементы.ФормаОбщаяКомандаАкцептоватьИзмененияВСправочнике.Видимость Тогда
	
		Отказ = Истина;
		Возврат;
	
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Организации.Ссылка
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.ОКПО = &ОКПО
	|	И НЕ Организации.ПометкаУдаления
	|	И НЕ Организации.Ссылка = &Ссылка
	|	И НЕ Организации.ОКПО = """"";
	
	Запрос.УстановитьПараметр("ОКПО", СокрЛП(ТекущийОбъект.ОКПО));
	Запрос.УстановитьПараметр("Ссылка", ТекущийОбъект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Если РезультатЗапроса.Следующий() Тогда
		
		Сообщить("В справочнике уже есть элемент с таким ОКПО!", СтатусСообщения.Важное);
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация	
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтотОбъект, Объект, "ГруппаКонтактнаяИнформация", ПоложениеЗаголовкаЭлементаФормы.Лево);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// ++ 22.05.2018 13:15:50 Базунов Д.А. Задача: 
	Элементы.СтраницаПредметыСнабжения.Видимость = ЗначениеЗаполнено(Объект.Ссылка);
	// -- 22.05.2018 13:15:50 Базунов Д.А. Задача:
	
	ЭлементОтбора = СписокПредметовСнабжения.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИзготовителиИПоставщики.Контрагент");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Объект.Ссылка;
	ЭлементОтбора.Использование = Истина;
	
	//++ 13.03.2018 Веденеев П. //отключение непосредственного изменения данных
	КорректировкаДанныхСправочников.ОтключитьНепосредственноеИзменениеДанных(ЭтаФорма);
	
	Элементы.ФормаЗапросНаАктуализациюКаталогаПоставщика.Видимость = РольДоступна("ПолныеПрава") Или РольДоступна("РуководительПроектаИССЗИПЭ"); 
		
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Объект, Отказ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	//++ 13.03.2018 Веденеев П. //отключение непосредственного изменения данных
	КорректировкаДанныхСправочников.ОтключитьНепосредственноеИзменениеДанных(ЭтаФорма);
	
КонецПроцедуры

// СтандартныеПодсистемы.КонтактнаяИнформация
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
    УправлениеКонтактнойИнформациейКлиент.ПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
    УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
    УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
    УправлениеКонтактнойИнформациейКлиент.Очистка(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
    УправлениеКонтактнойИнформациейКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда.Имя);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОбновитьКонтактнуюИнформацию(Результат)
    УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
КонецПроцедуры

// Конец СтандартныеПодсистемы.КонтактнаяИнформация

//++ 21.03.2018 Веденеев П. //старт БП "Запрос на актуализацию каталога поставщика"
&НаКлиенте
Процедура ЗапросНаАктуализациюКаталогаПоставщика(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПоказатьПредупреждение(, "Сначала нужно записать элемент!");
		Возврат;
		
	КонецЕсли;
	
	Если ЕстьПредметыСнабжения(Объект.Ссылка) Тогда
		
		ДанныеБизнесПроцесса = ПолучитьСтруктуруДанныхБизнесПроцесса(Объект.Ссылка);
		
		ОткрытьФорму("БизнесПроцесс.ЗапросНаАктуализациюКаталогаПоставщика.Форма.ФормаБизнесПроцесса", 
			Новый Структура("ДанныеБизнесПроцесса", ДанныеБизнесПроцесса));
		
	Иначе
		
		ПоказатьПредупреждение(, "Данная организация не является поставщиком/изготовителем/разработчиком предметов снабжения!");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕстьПредметыСнабжения(Организация)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КаталогПредметовСнабженияИзготовителиИПоставщики.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.КаталогПредметовСнабжения.ИзготовителиИПоставщики КАК КаталогПредметовСнабженияИзготовителиИПоставщики
	|ГДЕ
	|	КаталогПредметовСнабженияИзготовителиИПоставщики.Контрагент = &Организация";
	Запрос.УстановитьПараметр("Организация", Организация);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат Не РезультатЗапроса.Пустой();
	
КонецФункции

&НаСервере
Функция ПолучитьСтруктуруДанныхБизнесПроцесса(Знач Ссылка);
	
	СтруктураДанныхБизнесПроцесса = Новый Структура;
	
	СтруктураДанныхБизнесПроцесса.Вставить("Наименование", "Запрос на актуализацию информации о предметах снабжения контрагенту " + Ссылка.Наименование);
	СтруктураДанныхБизнесПроцесса.Вставить("Важность", Перечисления.ВариантыВажностиЗадачи.Обычная);
	СтруктураДанныхБизнесПроцесса.Вставить("Дата", ТекущаяДата());
	СтруктураДанныхБизнесПроцесса.Вставить("Автор", ПараметрыСеанса.ТекущийПользователь);
	СтруктураДанныхБизнесПроцесса.Вставить("АвторСтрокой", Строка(СтруктураДанныхБизнесПроцесса.Автор));
	СтруктураДанныхБизнесПроцесса.Вставить("Исполнитель", ПараметрыСеанса.ТекущийПользователь);
	СтруктураДанныхБизнесПроцесса.Вставить("Предмет", Ссылка);
	СтруктураДанныхБизнесПроцесса.Вставить("Содержание", 
		"При старте бизнес-процесса будет сформирован файл для отправки поставщику и создана задача для обработки принятия ответа");
	СтруктураДанныхБизнесПроцесса.Вставить("НаПроверке", Ложь);
	СтруктураДанныхБизнесПроцесса.Вставить("Проверяющий", Неопределено);
	
	Возврат СтруктураДанныхБизнесПроцесса;
	
КонецФункции

//-- 21.03.2018 Веденеев П. //старт БП З"апрос на актуализацию каталога поставщика"
