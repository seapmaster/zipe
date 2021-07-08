////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// Внутренние процедуры и функции для работы с журналом регистрации.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Записывает сообщение в журнал регистрации. 
// Если параметр ЗаписатьСобытия = Истина, то запись выполняется сразу (обращение к серверу). 
// Если ЗаписатьСобытия = Ложь (по умолчанию), то сообщение помещается в очередь, 
// которая может быть записана позднее, при следующем вызове этой или другой процедуры,
// в которую передается в качестве параметра очередь СообщенияДляЖурналаРегистрации.
//
//  Параметры: 
//   ИмяСобытия          - Строка - имя события для журнала регистрации;
//   ПредставлениеУровня - Строка - описание уровня события, по нему будет определен уровень события при записи на
//                                  сервере;
//                                  Например: "Ошибка", "Предупреждение".
//                                  Соответствуют именам элементов перечисления УровеньЖурналаРегистрации.
//   Комментарий         - Строка - комментарий для события журнала;
//   ДатаСобытия         - Дата   - точная дата возникновения события, описанного в сообщении. Будет добавлена в начало
//                                  комментария;
//   ЗаписатьСобытия     - Булево - выполнить запись всех ранее накопленных сообщений в журнал регистрации (обращение к
//                                  серверу).
//
// Пример:
//  ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СобытиеЖурналаРегистрации(), "Предупреждение",
//     НСтр("ru = 'Невозможно подключиться к сети Интернет для проверки обновлений.'"));
//
Процедура ДобавитьСообщениеДляЖурналаРегистрации(Знач ИмяСобытия, Знач ПредставлениеУровня = "Информация", 
	Знач Комментарий = "", Знач ДатаСобытия = "", Знач ЗаписатьСобытия = Ложь) Экспорт
	
	ИмяПроцедуры = "ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации";
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "ИмяСобытия", ИмяСобытия, Тип("Строка"));
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "ПредставлениеУровня", ПредставлениеУровня, Тип("Строка"));
	ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "Комментарий", Комментарий, Тип("Строка"));
	Если ДатаСобытия <> "" Тогда
		ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "ДатаСобытия", ДатаСобытия, Тип("Дата"));
	КонецЕсли;
	
	ИмяПараметра = "СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Новый СписокЗначений);
	КонецЕсли;
	
	Если ТипЗнч(ДатаСобытия) = Тип("Дата") Тогда
		ДатаСобытия = Формат(ДатаСобытия, "ДЛФ=DT");
	КонецЕсли;
	
	СтруктураСообщения = Новый Структура;
	СтруктураСообщения.Вставить("ИмяСобытия", ИмяСобытия);
	СтруктураСообщения.Вставить("ПредставлениеУровня", ПредставлениеУровня);
	СтруктураСообщения.Вставить("Комментарий", Комментарий);
	СтруктураСообщения.Вставить("ДатаСобытия", ДатаСобытия);
	//АВ+
	ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"].Добавить(СтруктураСообщения);
	
	Если ЗаписатьСобытия Тогда
		ЖурналРегистрацииВызовСервера.ЗаписатьСобытияВЖурналРегистрации(ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"]);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Открывает форму журнала регистрации с установленным отбором.
//
// Параметры:
//  Отбор - Структура - поля и значения, по которым необходимо отфильтровать журнал.
//  Владелец - УправляемаяФорма - форма, из которой открывается журнал регистрации.
//
Процедура ОткрытьЖурналРегистрации(Знач Отбор = Неопределено, Владелец = Неопределено) Экспорт
	
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма", Отбор, Владелец);
	
КонецПроцедуры

// Открывает форму для просмотра дополнительных данных события.
//
// Параметры:
//  ТекущиеДанные - Строка таблицы значений - строка журнала регистрации.
//
Процедура ОткрытьДанныеДляПросмотра(ТекущиеДанные) Экспорт
	
	Если ТекущиеДанные = Неопределено Или ТекущиеДанные.Данные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Эта запись журнала регистрации не связана с данными (см. колонку ""Данные"")'"));
		Возврат;
	КонецЕсли;
	
	Попытка
		ПоказатьЗначение(, ТекущиеДанные.Данные);
	Исключение
		ТекстПредупреждения = НСтр("ru = 'Эта запись журнала регистрации связана с данными, но отобразить их невозможно.
									|%1'");
		Если ТекущиеДанные.Событие = "_$Data$_.Delete" Тогда 
			// это - событие удаления
			ТекстПредупреждения =
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПредупреждения, НСтр("ru = 'Данные удалены из информационной базы'"));
		Иначе
			ТекстПредупреждения =
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПредупреждения, НСтр("ru = 'Возможно, данные удалены из информационной базы'"));
		КонецЕсли;
		ПоказатьПредупреждение(, ТекстПредупреждения);
	КонецПопытки;
	
КонецПроцедуры

// Открывает форму просмотра события обработки "Журнал регистрации"
// для отображения в ней подробных данных выбранного события.
//
// Параметры:
//  Данные  - Строка таблицы значений - строка журнала регистрации.
//
Процедура ПросмотрТекущегоСобытияВОтдельномОкне(Данные) Экспорт
	
	Если Данные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КлючУникальностиФормы = Данные.АдресДанных;
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.Событие", СобытиеЖурналаРегистрацииВСтруктуру(Данные),, КлючУникальностиФормы);
	
КонецПроцедуры

// Запрашивает у пользователя ограничение периода 
// и включает его в отбор журнала регистрации.
//
// Параметры:
//  ИнтервалДат - СтандартныйПериод, интервал дат отбора.
//  ОтборЖурналаРегистрации - Структура, отбор журнала регистрации.
//
Процедура УстановитьИнтервалДатДляПросмотра(ИнтервалДат, ОтборЖурналаРегистрации, ОбработчикОповещения = Неопределено) Экспорт
	
	// Получение текущего периода
	ДатаНачала    = Неопределено;
	ДатаОкончания = Неопределено;
	ОтборЖурналаРегистрации.Свойство("ДатаНачала", ДатаНачала);
	ОтборЖурналаРегистрации.Свойство("ДатаОкончания", ДатаОкончания);
	ДатаНачала    = ?(ТипЗнч(ДатаНачала)    = Тип("Дата"), ДатаНачала, '00010101000000');
	ДатаОкончания = ?(ТипЗнч(ДатаОкончания) = Тип("Дата"), ДатаОкончания, '00010101000000');
	
	Если ИнтервалДат.ДатаНачала <> ДатаНачала Тогда
		ИнтервалДат.ДатаНачала = ДатаНачала;
	КонецЕсли;
	
	Если ИнтервалДат.ДатаОкончания <> ДатаОкончания Тогда
		ИнтервалДат.ДатаОкончания = ДатаОкончания;
	КонецЕсли;
	
	// Редактирование текущего периода.
	Диалог = Новый ДиалогРедактированияСтандартногоПериода;
	Диалог.Период = ИнтервалДат;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОтборЖурналаРегистрации", ОтборЖурналаРегистрации);
	ДополнительныеПараметры.Вставить("ИнтервалДат", ИнтервалДат);
	ДополнительныеПараметры.Вставить("ОбработчикОповещения", ОбработчикОповещения);
	
	Оповещение = Новый ОписаниеОповещения("УстановитьИнтервалДатДляПросмотраЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	Диалог.Показать(Оповещение);
	
КонецПроцедуры

// Выполняет обработку выбора отдельного события в таблице событий.
//
// Параметры:
//  ТекущиеДанные - Строка таблицы значений - строка журнала регистрации.
//  Поле - Поле таблицы значений - поле.
//  ИнтервалДат - интервал.
//  ОтборЖурналаРегистрации - Отбор - отбор журнала регистрации.
//
Процедура СобытияВыбор(ТекущиеДанные, Поле, ИнтервалДат, ОтборЖурналаРегистрации) Экспорт
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле.Имя = "Данные" Или Поле.Имя = "ПредставлениеДанных" Тогда
		Если ТекущиеДанные.Данные <> Неопределено
			И Не ЗначениеЗаполнено(ТекущиеДанные.Комментарий)
			И (ТипЗнч(ТекущиеДанные.Данные) <> Тип("Строка")
			И ЗначениеЗаполнено(ТекущиеДанные.Данные)) Тогда
			
			ОткрытьДанныеДляПросмотра(ТекущиеДанные);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если Поле.Имя = "Дата" Тогда
		УстановитьИнтервалДатДляПросмотра(ИнтервалДат, ОтборЖурналаРегистрации);
		Возврат;
	КонецЕсли;
	
	ПросмотрТекущегоСобытияВОтдельномОкне(ТекущиеДанные);
	
КонецПроцедуры

// Заполняет отбор в соответствии с значением в текущей колонке событий.
//
// Параметры:
//  ТекущиеДанные - Строка таблицы значений.
//  ТекущийЭлемент - Текущий элемент строки таблицы значений.
//  ОтборЖурналаРегистрации - Отбор - отбор журнала регистрации.
//  КолонкиИсключения - Список значений - колонки исключения.
//
// Возвращаемое значение:
//  Булево - Истина, если отбор установлен, Ложь - Иначе.
//
Функция УстановитьОтборПоЗначениюВТекущейКолонке(ТекущиеДанные, ТекущийЭлемент, ОтборЖурналаРегистрации, КолонкиИсключения) Экспорт
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ИмяКолонкиПредставления = ТекущийЭлемент.Имя;
	
	Если ИмяКолонкиПредставления = "ПредставлениеРазделенияДанныхСеанса" Тогда
		//АВ+
		ОтборЖурналаРегистрации.Удалить("ПредставлениеРазделенияДанныхСеанса");
		ОтборЖурналаРегистрации.Вставить("РазделениеДанныхСеанса", ТекущиеДанные.РазделениеДанныхСеанса);
		ИмяКолонкиПредставления = "РазделениеДанныхСеанса";
	КонецЕсли;
	
	Если КолонкиИсключения.Найти(ИмяКолонкиПредставления) <> Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	ЗначениеОтбора = ТекущиеДанные[ИмяКолонкиПредставления];
	Представление  = ТекущиеДанные[ИмяКолонкиПредставления];
	
	ИмяЭлементаОтбора = ИмяКолонкиПредставления;
	Если ИмяКолонкиПредставления = "ИмяПользователя" Тогда 
		ИмяЭлементаОтбора = "Пользователь";
		ЗначениеОтбора = ТекущиеДанные["Пользователь"];
	ИначеЕсли ИмяКолонкиПредставления = "ПредставлениеПриложения" Тогда
		ИмяЭлементаОтбора = "ИмяПриложения";
		ЗначениеОтбора = ТекущиеДанные["ИмяПриложения"];
	ИначеЕсли ИмяКолонкиПредставления = "ПредставлениеСобытия" Тогда
		ИмяЭлементаОтбора = "Событие";
		ЗначениеОтбора = ТекущиеДанные["Событие"];
	КонецЕсли;
	
	// По пустым строкам не отбираем.
	Если ТипЗнч(ЗначениеОтбора) = Тип("Строка") И ПустаяСтрока(ЗначениеОтбора) Тогда
		// Для пользователя по умолчанию имя пустое, разрешаем отбирать.
		Если ИмяКолонкиПредставления <> "ИмяПользователя" Тогда 
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ТекущееЗначение = Неопределено;
	Если ОтборЖурналаРегистрации.Свойство(ИмяЭлементаОтбора, ТекущееЗначение) Тогда
		// Уже установлен отбор
		//АВ+
		ОтборЖурналаРегистрации.Удалить(ИмяЭлементаОтбора);
	КонецЕсли;
	
	Если ИмяЭлементаОтбора = "Данные" // Не списочные отборы, только 1 значение.
		Или ИмяЭлементаОтбора = "Комментарий"
		Или ИмяЭлементаОтбора = "Транзакция"
		Или ИмяЭлементаОтбора = "ПредставлениеДанных" Тогда
		ОтборЖурналаРегистрации.Вставить(ИмяЭлементаОтбора, ЗначениеОтбора);
	Иначе
		
		Если ИмяЭлементаОтбора = "РазделениеДанныхСеанса" Тогда
			СписокОтбора = ЗначениеОтбора.Скопировать();
		Иначе
			СписокОтбора = Новый СписокЗначений;
			СписокОтбора.Добавить(ЗначениеОтбора, Представление);
		КонецЕсли;
		
		ОтборЖурналаРегистрации.Вставить(ИмяЭлементаОтбора, СписокОтбора);
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Только для внутреннего использования.
//
Функция СобытиеЖурналаРегистрацииВСтруктуру(Данные)
	
	Если ТипЗнч(Данные) = Тип("Структура") Тогда
		Возврат Данные;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Дата",                    Данные.Дата);
	ПараметрыФормы.Вставить("ИмяПользователя",         Данные.ИмяПользователя);
	ПараметрыФормы.Вставить("ПредставлениеПриложения", Данные.ПредставлениеПриложения);
	ПараметрыФормы.Вставить("Компьютер",               Данные.Компьютер);
	ПараметрыФормы.Вставить("Событие",                 Данные.Событие);
	ПараметрыФормы.Вставить("ПредставлениеСобытия",    Данные.ПредставлениеСобытия);
	ПараметрыФормы.Вставить("Комментарий",             Данные.Комментарий);
	ПараметрыФормы.Вставить("ПредставлениеМетаданных", Данные.ПредставлениеМетаданных);
	ПараметрыФормы.Вставить("Данные",                  Данные.Данные);
	ПараметрыФормы.Вставить("ПредставлениеДанных",     Данные.ПредставлениеДанных);
	ПараметрыФормы.Вставить("Транзакция",              Данные.Транзакция);
	ПараметрыФормы.Вставить("СтатусТранзакции",        Данные.СтатусТранзакции);
	ПараметрыФормы.Вставить("Сеанс",                   Данные.Сеанс);
	ПараметрыФормы.Вставить("РабочийСервер",           Данные.РабочийСервер);
	ПараметрыФормы.Вставить("ОсновнойIPПорт",          Данные.ОсновнойIPПорт);
	ПараметрыФормы.Вставить("ВспомогательныйIPПорт",   Данные.ВспомогательныйIPПорт);
	
	Если Данные.Свойство("РазделениеДанныхСеанса") Тогда
		ПараметрыФормы.Вставить("РазделениеДанныхСеанса", Данные.РазделениеДанныхСеанса);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Данные.АдресДанных) Тогда
		ПараметрыФормы.Вставить("АдресДанных", Данные.АдресДанных);
	КонецЕсли;
	
	Возврат ПараметрыФормы;
КонецФункции

// Только для внутреннего использования.
//
Процедура УстановитьИнтервалДатДляПросмотраЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ОтборЖурналаРегистрации = ДополнительныеПараметры.ОтборЖурналаРегистрации;
	ИнтервалУстановлен = Ложь;
	
	Если Результат <> Неопределено Тогда
		
		// Обновление текущего периода.
		ИнтервалДат = Результат;
		Если ИнтервалДат.ДатаНачала = '00010101000000' Тогда
			//АВ+
			ОтборЖурналаРегистрации.Удалить("ДатаНачала");
		Иначе
			ОтборЖурналаРегистрации.Вставить("ДатаНачала", ИнтервалДат.ДатаНачала);
		КонецЕсли;
		
		Если ИнтервалДат.ДатаОкончания = '00010101000000' Тогда
			//АВ+
			ОтборЖурналаРегистрации.Удалить("ДатаОкончания");
		Иначе
			ОтборЖурналаРегистрации.Вставить("ДатаОкончания", ИнтервалДат.ДатаОкончания);
		КонецЕсли;
		ИнтервалУстановлен = Истина;
		
	КонецЕсли;
	
	Если ДополнительныеПараметры.ОбработчикОповещения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОбработчикОповещения, ИнтервалУстановлен);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
