
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("РежимОткрытияОкна") Тогда
		РежимОткрытияОкна = Параметры.РежимОткрытияОкна
	КонецЕсли;
	
	Параметры.Свойство("РежимВыбора", РежимВыбора);
	Элементы.Классификатор.РежимВыбора = РежимВыбора;
	
	ЗакрыватьПриВыборе = РежимВыбора;
	
	// Служебные реквизиты
	ПоляКлассификатора = "Код, Наименование, ПолноеНаименованиеСтраны, БуквенныйКодАльфа2, БуквенныйКодАльфа3";
	
	Мета = Метаданные.Справочники.ОКСМ;
	ПредставлениеОбъектаКлассификатора = Мета.РасширенноеПредставлениеОбъекта;
	Если ПустаяСтрока(ПредставлениеОбъектаКлассификатора) Тогда
		ПредставлениеОбъектаКлассификатора = Мета.ПредставлениеОбъекта;
	КонецЕсли;
	Если ПустаяСтрока(ПредставлениеОбъектаКлассификатора) Тогда
		ПредставлениеОбъектаКлассификатора = Мета.Представление();
	КонецЕсли;
	Если Не ПустаяСтрока(ПредставлениеОбъектаКлассификатора) Тогда
		ПредставлениеОбъектаКлассификатора = " (" + ПредставлениеОбъектаКлассификатора + ")";
	КонецЕсли;
	
	ДанныеКлассификатора = СостояниеКлассификатора();
	Классификатор.Загрузить(ДанныеКлассификатора);
	
	Фильтр = Классификатор.НайтиСтроки(Новый Структура("Код", Параметры.ТекущаяСтрока.Код));
	Если Фильтр.Количество()>0 Тогда
		Элементы.Классификатор.ТекущаяСтрока = Фильтр[0].ПолучитьИдентификатор();
	КонецЕсли;
	
	Элементы.КлассификаторКонтекстноеМенюИзменить.Видимость = ПравоДоступа("Изменение", Метаданные.Справочники.ОКСМ);
	
	ЕстьПравоРедактироватьСтраны = ПравоДоступа("Изменение", Метаданные.Справочники.ОКСМ);
	Элементы.КлассификаторКонтекстноеМенюИзменить.Видимость = ЕстьПравоРедактироватьСтраны;
	Элементы.КлассификаторИзменить.Видимость = ЕстьПравоРедактироватьСтраны;
	Элементы.Классификатор.ТолькоПросмотр = НЕ ЕстьПравоРедактироватьСтраны;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКлассификатор

&НаКлиенте
Процедура КлассификаторВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Если ВыбраннаяСтрока = Неопределено Или Не ЕстьПравоРедактироватьСтраны Тогда
		Возврат;
	КонецЕсли;

	Если Не РежимВыбора Тогда
		Страна = Классификатор.НайтиПоИдентификатору(ВыбраннаяСтрока);
		
		Если СтраныНетВСпискеСтран(Страна.Наименование) Тогда
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Добавить страну ""%1"" из классификатора в список стран мира?'"),
				Страна.Наименование);
			Оповещение = Новый ОписаниеОповещения("ДобавитьСтрану", ЭтотОбъект, ВыбраннаяСтрока);
			ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		КонецЕсли;
	Иначе
		Если ТипЗнч(ВыбраннаяСтрока) = Тип("Массив") Тогда
			ИдентификаторСтрокиВыбора = ВыбраннаяСтрока[0];
		Иначе
			ИдентификаторСтрокиВыбора = ВыбраннаяСтрока;
		КонецЕсли;
		
		ОповеститьОВыбореЭлементаКлассификатора(ИдентификаторСтрокиВыбора);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСтрану(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		ОповеститьОВыбореЭлементаКлассификатора(ДополнительныеПараметры);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КлассификаторВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	ОповеститьОВыбореЭлементаКлассификатора(Значение);
КонецПроцедуры

&НаКлиенте
Процедура КлассификаторПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	Если ЕстьПравоРедактироватьСтраны Тогда
		ОткрытьФормуЭлементаКлассификатора(Элементы.Классификатор.ТекущиеДанные);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КлассификаторПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура КлассификаторПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьФормуЭлементаКлассификатора(ДанныеЗаполнения, ЭтоНовый = Ложь)
	Если ДанныеЗаполнения=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Основание", Новый Структура(ПоляКлассификатора));
	ЗаполнитьЗначенияСвойств(ПараметрыФормы.Основание, ДанныеЗаполнения);
	Если ЭтоНовый Тогда
		ПараметрыФормы.Основание.Вставить("Код", "--");
	Иначе
		ПараметрыФормы.Вставить("ТолькоПросмотр", Истина);
	КонецЕсли;
	Форма = ОткрытьФорму("Справочник.ОКСМ.ФормаОбъекта", ПараметрыФормы, Элементы.Классификатор);
	Если Не ЭтоНовый И Форма.АвтоЗаголовок Тогда 
		Форма.АвтоЗаголовок = Ложь;
		Форма.Заголовок = ДанныеЗаполнения.Наименование + ПредставлениеОбъектаКлассификатора;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОВыбореЭлементаКлассификатора(ИдентификаторСтрокиВыбора)
	ВсеДанныеСтроки = Классификатор.НайтиПоИдентификатору(ИдентификаторСтрокиВыбора);
	Если ВсеДанныеСтроки <> Неопределено Тогда
		ДанныеСтроки = Новый Структура(ПоляКлассификатора);
		ЗаполнитьЗначенияСвойств(ДанныеСтроки, ВсеДанныеСтроки);
		
		ДанныеВыбора = ДанныеВыбораЭлементаКлассификатора(ДанныеСтроки);
		Если ДанныеВыбора.ЭтоНовый Тогда
			ОповеститьОСозданииЭлементов(ДанныеВыбора.Ссылка);
		КонецЕсли;
		
		ОповеститьОВыборе(ДанныеВыбора.Ссылка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОСозданииЭлементов(Ссылка)
	ОповеститьОЗаписиНового(Ссылка);
	Оповестить("Справочник.ОКСМ.Изменение", Ссылка, ЭтотОбъект);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеВыбораЭлементаКлассификатора(Знач ДанныеСтраны)
	// Ищем только по коду, так как в классификаторе все коды заданы.
	Ссылка = Справочники.ОКСМ.НайтиПоКоду(ДанныеСтраны.Код);
	ЭтоНовый = Не ЗначениеЗаполнено(Ссылка);
	Если ЭтоНовый Тогда
		Страна = Справочники.ОКСМ.СоздатьЭлемент();
		ЗаполнитьЗначенияСвойств(Страна, ДанныеСтраны);
		Страна.Записать();
		Ссылка = Страна.Ссылка;
	КонецЕсли;
	
	Возврат Новый Структура("Ссылка, ЭтоНовый, Код", Ссылка, ЭтоНовый, ДанныеСтраны.Код);
КонецФункции

&НаСервереБезКонтекста
Функция СостояниеКлассификатора()
	Данные = Справочники.ОКСМ.ТаблицаКлассификатора();
	
	Данные.Колонки.Добавить("ИндексПиктограммы", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(2, 0)));
	Данные.ЗаполнитьЗначения(8, "ИндексПиктограммы");
	
	Запрос = Новый Запрос("ВЫБРАТЬ Код ИЗ Справочник.ОКСМ ГДЕ Предопределенный");
	Для Каждого СтрокаПредопределенного Из Запрос.Выполнить().Выгрузить() Цикл
		СтрокаДанных = Данные.Найти(СтрокаПредопределенного.Код, "Код");
		Если СтрокаДанных<>Неопределено Тогда
			СтрокаДанных.ИндексПиктограммы = 5;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Данные;
КонецФункции

&НаСервереБезКонтекста
Функция СтраныНетВСпискеСтран(Страна)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ОКСМ.Ссылка
		|ИЗ Справочник.ОКСМ КАК ОКСМ
		|ГДЕ ОКСМ.Наименование = &Наименование";
	
	Запрос.УстановитьПараметр("Наименование", Страна);
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Если РезультатЗапроса.Следующий() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти
