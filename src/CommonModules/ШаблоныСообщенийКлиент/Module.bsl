#Область ПрограммныйИнтерфейс

// Открывает форму для выбора шаблона.
//
// Параметры:
//   Оповещение - ОписаниеОповещения - оповещение, которое будет вызвано после выбора шаблона с готовым сообщением.
//
Процедура ВыбратьШаблон(Оповещение) Экспорт
	
	ДополнительныеПараметры = Новый Структура("Оповещение", Оповещение);
	ПараметрыФормы = Новый Структура("Назначение, РежимВыбора, ВидСообщения", "Общий", Истина, "ЭлектронноеПисьмо");
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьПоШаблонуПослеВыбораШаблона", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("Справочник.ШаблоныСообщений.Форма.СформироватьСообщение", ПараметрыФормы, ЭтотОбъект,,,, Оповещение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПоШаблонуПослеВыбораШаблона(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.Оповещение, Результат);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти



