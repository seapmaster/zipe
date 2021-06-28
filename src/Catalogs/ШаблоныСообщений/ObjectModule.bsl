#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если ДанныеЗаполнения <> Неопределено Тогда
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Взаимодействия")
			И ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее") Тогда
				ЗаполнитьНаОснованииЭлектронноеПисьмоИсходящее(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
		ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда 
				ЗаполнитьНаОснованииСтруктуры(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьНаОснованииЭлектронноеПисьмоИсходящее(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ЭтотОбъект.ТемаПисьма = ДанныеЗаполнения.Тема;
	ЭтотОбъект.ТекстШаблонаПисьмаHTML = ДанныеЗаполнения.ТекстHTML;
	ЭтотОбъект.ТекстШаблонаПисьма = ДанныеЗаполнения.Текст;
	ЭтотОбъект.ТемаПисьма = ДанныеЗаполнения.Тема;
	ЭтотОбъект.Наименование = ДанныеЗаполнения.Тема;
	ЭтотОбъект.ПредназначенДляЭлектронныхПисем = Истина;
	ЭтотОбъект.ПредназначенДляSMS = Ложь;
	Если ДанныеЗаполнения.ТипТекста = Перечисления.ТипыТекстовЭлектронныхПисем.HTML
		ИЛИ ДанныеЗаполнения.ТипТекста = Перечисления.ТипыТекстовЭлектронныхПисем.HTMLСКартинками  Тогда
		ЭтотОбъект.ТипТекстаПисьма = Перечисления.СпособыРедактированияЭлектронныхПисем.HTML;
	Иначе
		ЭтотОбъект.ТипТекстаПисьма = Перечисления.СпособыРедактированияЭлектронныхПисем.ОбычныйТекст;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииСтруктуры(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ПараметрыШаблона = ШаблоныСообщений.ОписаниеПараметровШаблона();
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ПараметрыШаблона, ДанныеЗаполнения, Истина);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыШаблона);
	
	Если ЗначениеЗаполнено(ПараметрыШаблона.ВнешняяОбработка) Тогда
		ЭтотОбъект.ШаблонПоВнешнейОбработке = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыШаблона.ПолноеИмяТипаНазначения) Тогда
		МетаданныеОбъекта = Метаданные.НайтиПоПолномуИмени(ПараметрыШаблона.ПолноеИмяТипаНазначения);
		ЭтотОбъект.ПолноеИмяТипаПараметраВводаНаОсновании = ПараметрыШаблона.ПолноеИмяТипаНазначения;
		ЭтотОбъект.Назначение= МетаданныеОбъекта.Представление();
		ЭтотОбъект.ПредназначенДляВводаНаОсновании = Истина;
	КонецЕсли;
	
	Если ПараметрыШаблона.Служебный Тогда
		ЭтотОбъект.Назначение = "Служебный";
		Если ДанныеЗаполнения.Свойство("КлючНазначенияИспользования") Тогда
			ЭтотОбъект.Назначение = ЭтотОбъект.Назначение + ":" + ДанныеЗаполнения.КлючНазначенияИспользования;
		КонецЕсли;
	КонецЕсли;
	
	Если ПараметрыШаблона.ТипШаблона = "Письмо" Тогда
		ЭтотОбъект.ПредназначенДляSMS = Ложь;
		ЭтотОбъект.ПредназначенДляЭлектронныхПисем = Истина;
		ЭтотОбъект.ТемаПисьма = ПараметрыШаблона.Тема;
		Если ПараметрыШаблона.ФорматПисьма = Перечисления.СпособыРедактированияЭлектронныхПисем.HTML Тогда
			ЭтотОбъект.ТекстШаблонаПисьмаHTML = ПараметрыШаблона.Текст;
			ЭтотОбъект.ТипТекстаПисьма = Перечисления.СпособыРедактированияЭлектронныхПисем.HTML;
		Иначе
			ЭтотОбъект.ТекстШаблонаПисьма = ПараметрыШаблона.Текст;
			ЭтотОбъект.ТипТекстаПисьма = Перечисления.СпособыРедактированияЭлектронныхПисем.ОбычныйТекст;
		КонецЕсли;
	ИначеЕсли ПараметрыШаблона.ТипШаблона = "SMS" Тогда
		ЭтотОбъект.ПредназначенДляSMS = Истина;
		ЭтотОбъект.ПредназначенДляЭлектронныхПисем = Ложь;
		ЭтотОбъект.ТекстШаблонаSMS = ПараметрыШаблона.Текст;
		ЭтотОбъект.ОтправлятьВТранслите = ПараметрыШаблона.ПеревестиВТранслит;
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
