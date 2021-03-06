
///////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Область Сервис

&НаСервере
Функция ПроверкаПройденаУспешно()
	
	Ответ = Ложь;
	
	Если ЗначениеЗаполнено(СтрокаПоиска) И ЗначениеЗаполнено(СтрокаЗамены) И ЗначениеЗаполнено(РеквизитЗамены) Тогда
		
		Ответ = Истина;
		
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции	//ПроверкаПройденаУспешно

#КонецОбласти

#Область Действия

&НаСервере
Процедура ПодготовкаКЗаменеСимволов()
	
	Если ПроверкаПройденаУспешно() Тогда
		
		Для Каждого СтрПС Из ТаблицаДляОбработки Цикл
			
			ЗаменитьСимволыВОбъекте(СтрПС.ПредметСнабжения);
			
			ЗаполнитьРеквизитыОбъекта(СтрПС);
			
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры	//ПодготовкаКЗаменеСимволов

&НаСервере
Процедура ЗаменитьСимволыВОбъекте(ПредметСсылка)

	тОбъект = ПредметСсылка.ПолучитьОбъект();
	ИзначальноеЗначение = тОбъект[РеквизитЗамены];
	ИзначальноеЗначение = СтрЗаменить(ИзначальноеЗначение, СтрокаПоиска, СтрокаЗамены);
	
	Если ИзначальноеЗначение <> тОбъект[РеквизитЗамены] Тогда
		
		тОбъект[РеквизитЗамены] = ИзначальноеЗначение;
		
		тОбъект.Записать();
		
	КонецЕсли;

КонецПроцедуры	//ЗаменитьСимволыВОбъекте

#КонецОбласти

#Область ЗаполнениеТаблиц

&НаСервере
Процедура ЗаполнитьТаблицуДляОбработки(АдресМассива)

	МассивДинСписка = ПолучитьИзВременногоХранилища(АдресМассива);
	
	Для Каждого элМассива Из МассивДинСписка Цикл
		
		нСтрока = ТаблицаДляОбработки.Добавить();
		нСтрока.ПредметСнабжения 	= элМассива;
		нСтрока.Выбран 				= Истина;
		
		ЗаполнитьРеквизитыОбъекта(нСтрока);
		
	КонецЦикла;
	
КонецПроцедуры	//ЗаполнитьТаблицуДляОбработки

&НаСервере
Процедура ЗаполнитьРеквизитыОбъекта(тСтрока)
	
	Предмет = тСтрока.ПредметСнабжения;  
	
	тСтрока.Наименование 		= Предмет.Наименование;
	тСтрока.Обозначение 		= Предмет.Обозначение;
	тСтрока.ДокументНаПоставку 	= Предмет.ДокументНаПоставку;
	тСтрока.Шифр 				= Предмет.Шифр;
	тСтрока.ФНН 				= Предмет.ФНН;
	тСтрока.Комментарий 		= Предмет.Комментарий;
	
КонецПроцедуры	//ЗаполнитьРеквизитыОбъекта

#КонецОбласти

///////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД

#Область КомандыРедактирования

&НаКлиенте
Процедура Заменить(Команда)
	
	ПодготовкаКЗаменеСимволов();
	
КонецПроцедуры	//Заменить

#КонецОбласти

///////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

#Область ОбработчкикиФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АдресМассива") Тогда
		
		ЗаполнитьТаблицуДляОбработки(Параметры.АдресМассива);
		
		РеквизитЗамены = "Наименование";
		
	КонецЕсли;
	
КонецПроцедуры	//ПриСозданииНаСервере

#КонецОбласти
