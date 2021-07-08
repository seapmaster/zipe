#Область ОписаниеПеременных

&НаКлиенте
Перем ОткрытаФормаВыбораИсполнителя;  // Признак того, что исполнитель выбирается из формы, а не быстрым вводом.
&НаКлиенте
Перем ОткрытаФормаВыбораПроверяющего; // Признак того, что проверяющий выбирается из формы, а не быстрым вводом.
&НаКлиенте
Перем КонтекстВыбора;

#КонецОбласти

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
		
		Объект.ВариантЗаполнения = 1;
		Объект.Наименование = "Каталогизация в АО ""Рособоронэкспорт""";
		Объект.Исполнитель = Справочники.РолиИсполнителей.СпециалистПоВедениюБДЗИПЭ;
		Объект.СрокИсполнения = ТекущаяДата() + 14 * 24*3600;
		
	КонецЕсли;
	
	Если Объект.Стартован Тогда
		Элементы.ФормаВыгрузитьВФайлИСтартовать.Доступность = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьДоступностьКомандОстановки();
	
	// Новый
	Если Объект.Ссылка.Пустая() Тогда
		ВариантЗаполненияНаСервере();
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ИнициализацияФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.ВыборРолиИсполнителя") Тогда
		
		Если КонтекстВыбора = "ИсполнительПриИзменении" Тогда
			
			Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
				Объект.Исполнитель = ВыбранноеЗначение.РольИсполнителя;
			КонецЕсли;
			
			УстановитьДоступностьПроверяющего(ЭтотОбъект);
			
		ИначеЕсли КонтекстВыбора = "ПроверяющийПриИзменении" Тогда
			
			Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
				Объект.Проверяющий = ВыбранноеЗначение.РольИсполнителя;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененаНастройкаОтложенногоСтарта" Тогда
		Отложен = (Параметр.Отложен И Параметр.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияПроцессовДляЗапуска.ГотовКСтарту"));
		ДатаОтложенногоСтарта = Параметр.ДатаОтложенногоСтарта;
		УстановитьСвойстваЭлементовФормы(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ПроверитьДатуЗавершенияОтложенногоПроцесса(ТекущийОбъект, Отказ);
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ИзменятьЗаданияЗаднимЧислом = ПолучитьФункциональнуюОпцию("ИзменятьЗаданияЗаднимЧислом");
	Если НачальныйПризнакСтарта И ИзменятьЗаданияЗаднимЧислом Тогда
		УстановитьПривилегированныйРежим(Истина); 
		ТекущийОбъект.ИзменитьРеквизитыНевыполненныхЗадач();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_Задание", ПараметрыЗаписи, Объект.Ссылка);
	Оповестить("Запись_ЗадачаИсполнителя", ПараметрыЗаписи, Неопределено);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаПроверкеПриИзменении(Элемент)
	
	УстановитьДоступностьПроверяющего(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(,Объект.Предмет);
	
КонецПроцедуры

&НаКлиенте
Процедура ГлавнаяЗадачаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(,Объект.ГлавнаяЗадача);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнфоНадписьЗаголовокОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьНастройкуОтложенногоСтарта();
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	БизнесПроцессыИЗадачиКлиент.ВыбратьИсполнителя(Элемент, Объект.Исполнитель);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительПриИзменении(Элемент)
	
	Если ОткрытаФормаВыбораИсполнителя = Истина Тогда
		Возврат;
	КонецЕсли;
	
	ОсновнойОбъектАдресации = Неопределено;
	ДополнительныйОбъектАдресации = Неопределено;
	
	Если ТипЗнч(Объект.Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей") И ЗначениеЗаполнено(Объект.Исполнитель) Тогда 
		
		Если ИспользуетсяСОбъектамиАдресации(Объект.Исполнитель) Тогда 
			
			КонтекстВыбора = "ИсполнительПриИзменении";
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("РольИсполнителя", Объект.Исполнитель);
			ПараметрыФормы.Вставить("ОсновнойОбъектАдресации", ОсновнойОбъектАдресации);
			ПараметрыФормы.Вставить("ДополнительныйОбъектАдресации", ДополнительныйОбъектАдресации);
			
			ОткрытьФорму("ОбщаяФорма.ВыборРолиИсполнителя", ПараметрыФормы, ЭтотОбъект);
			
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьДоступностьПроверяющего(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОткрытаФормаВыбораИсполнителя = ТипЗнч(ВыбранноеЗначение) = Тип("Структура");
	Если ОткрытаФормаВыбораИсполнителя Тогда
		СтандартнаяОбработка = Ложь;
		Объект.Исполнитель = ВыбранноеЗначение.РольИсполнителя;
		Объект.ОсновнойОбъектАдресации = ВыбранноеЗначение.ОсновнойОбъектАдресации;
		Объект.ДополнительныйОбъектАдресации = ВыбранноеЗначение.ДополнительныйОбъектАдресации;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = БизнесПроцессыИЗадачиВызовСервера.СформироватьДанныеВыбораИсполнителя(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = БизнесПроцессыИЗадачиВызовСервера.СформироватьДанныеВыбораИсполнителя(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверяющийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	БизнесПроцессыИЗадачиКлиент.ВыбратьИсполнителя(Элемент, Объект.Проверяющий);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверяющийПриИзменении(Элемент)
	
	Если ОткрытаФормаВыбораПроверяющего = Истина Тогда
		Возврат;
	КонецЕсли;
	
	ОсновнойОбъектАдресации = Неопределено;
	ДополнительныйОбъектАдресации = Неопределено;
	
	Если ТипЗнч(Объект.Проверяющий) = Тип("СправочникСсылка.РолиИсполнителей") И ЗначениеЗаполнено(Объект.Проверяющий) Тогда
		
		Если ИспользуетсяСОбъектамиАдресации(Объект.Проверяющий) Тогда
			
			КонтекстВыбора = "ПроверяющийПриИзменении";
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("РольИсполнителя", Объект.Проверяющий);
			ПараметрыФормы.Вставить("ОсновнойОбъектАдресации", ОсновнойОбъектАдресации);
			ПараметрыФормы.Вставить("ДополнительныйОбъектАдресации", ДополнительныйОбъектАдресации);
			
			ОткрытьФорму("ОбщаяФорма.ВыборРолиИсполнителя", ПараметрыФормы, ЭтотОбъект);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверяющийОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОткрытаФормаВыбораПроверяющего = ТипЗнч(ВыбранноеЗначение) = Тип("Структура");
	Если ОткрытаФормаВыбораПроверяющего Тогда
		СтандартнаяОбработка = Ложь;
		Объект.Проверяющий = ВыбранноеЗначение.РольИсполнителя;
		Объект.ОсновнойОбъектАдресацииПроверяющий = ВыбранноеЗначение.ОсновнойОбъектАдресации;
		Объект.ДополнительныйОбъектАдресацииПроверяющий = ВыбранноеЗначение.ДополнительныйОбъектАдресации;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверяющийАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = БизнесПроцессыИЗадачиВызовСервера.СформироватьДанныеВыбораИсполнителя(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверяющийОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = БизнесПроцессыИЗадачиВызовСервера.СформироватьДанныеВыбораИсполнителя(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИсполненияПриИзменении(Элемент)
	Если Объект.СрокИсполнения = НачалоДня(Объект.СрокИсполнения) Тогда
		Объект.СрокИсполнения = КонецДня(Объект.СрокИсполнения);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СрокПроверкиПриИзменении(Элемент)
	Если Объект.СрокПроверки = НачалоДня(Объект.СрокПроверки) Тогда
		Объект.СрокПроверки = КонецДня(Объект.СрокПроверки);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ОчиститьСообщения();
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;	
	КонецЕсли;
	
	Записать();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Остановить(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ОстановитьБизнесПроцессИзФормыОбъекта(ЭтотОбъект);
	ОбновитьДоступностьКомандОстановки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьБизнесПроцесс(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ПродолжитьБизнесПроцессИзФормыОбъекта(ЭтотОбъект);
	ОбновитьДоступностьКомандОстановки();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтложенныйСтарт(Команда)
	ОткрытьНастройкуОтложенногоСтарта();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализацияФормы()
	
	НачальныйПризнакСтарта = Объект.Стартован;
	
	УстановитьРеквизитыОтложенногоСтарта();
	
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	ИзменятьЗаданияЗаднимЧислом = ПолучитьФункциональнуюОпцию("ИзменятьЗаданияЗаднимЧислом");
	ИспользоватьПодчиненныеБизнесПроцессы = ПолучитьФункциональнуюОпцию("ИспользоватьПодчиненныеБизнесПроцессы");
	
	ПредметСтрокой = ОбщегоНазначения.ПредметСтрокой(Объект.Предмет);
	
	//Если Объект.ГлавнаяЗадача = Неопределено Или Объект.ГлавнаяЗадача.Пустая() Тогда
	//	ГлавнаяЗадачаСтрокой = НСтр("ru = 'не задана'");
	//Иначе	
	//	ГлавнаяЗадачаСтрокой = Строка(Объект.ГлавнаяЗадача);
	//КонецЕсли;
	
	УстановитьСвойстваЭлементовФормы(ЭтаФорма);
	
	Если Объект.Стартован Тогда
		ТолькоПросмотр = Истина;
		Элементы.Заполнить.Доступность = Ложь;
		Элементы.СУчетомСпецификации.ТолькоПросмотр = Истина;
		Элементы.РазвернутьДерево.ТолькоПросмотр = Истина;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДоступностьКомандОстановки()
	
	Если Объект.Завершен Тогда
		
		Элементы.ФормаОстановить.Доступность = Ложь;
		Элементы.ФормаПродолжить.Доступность = Ложь;
		Возврат;
		
	КонецЕсли;
	
	Если Объект.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияБизнесПроцессов.Остановлен") Тогда
		Элементы.ФормаОстановить.Доступность = Ложь;
		Элементы.ФормаПродолжить.Доступность = Истина;
	Иначе
		Элементы.ФормаОстановить.Доступность = Истина;
		Элементы.ФормаПродолжить.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьПроверяющего(Форма)
	
	ДоступностьПоля = Форма.Объект.НаПроверке;
	Форма.Элементы.ГруппаПроверяющий.Доступность = ДоступностьПоля;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИспользуетсяСОбъектамиАдресации(ПроверяемыйОбъект)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПроверяемыйОбъект, "ИспользуетсяСОбъектамиАдресации");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСвойстваЭлементовФормы(Форма)
	
	Если Форма.ТолькоПросмотр Тогда
		Форма.Элементы.ФормаОстановить.Видимость = Ложь;
		Форма.Элементы.ФормаЗаписатьИЗакрыть.Видимость = Ложь;
		Форма.Элементы.ФормаНастроитьОтложенныйСтарт.Видимость = Ложь;
		Форма.Элементы.ФормаЗаписать.Видимость = Ложь;
		Форма.Элементы.ФормаПродолжить.Видимость = Ложь;
	Иначе
		Форма.Элементы.СрокИсполненияВремя.Видимость = Форма.ИспользоватьДатуИВремяВСрокахЗадач;
		Форма.Элементы.СрокПроверкиВремя.Видимость = Форма.ИспользоватьДатуИВремяВСрокахЗадач;
		Форма.Элементы.Дата.Формат = ?(Форма.ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
		
		Форма.Элементы.Предмет.Гиперссылка = Форма.Объект.Предмет <> Неопределено И НЕ Форма.Объект.Предмет.Пустая();
		
		//Форма.Элементы.ФормаСтартИЗакрыть.Видимость = Не ОбъектСтартован(Форма);
		//Форма.Элементы.ФормаСтартИЗакрыть.КнопкаПоУмолчанию = Не ОбъектСтартован(Форма);
		Форма.Элементы.ФормаСтарт.Видимость = Не ОбъектСтартован(Форма); 
		Форма.Элементы.ФормаЗаписатьИЗакрыть.Видимость = ОбъектСтартован(Форма); 
		Форма.Элементы.ФормаЗаписатьИЗакрыть.КнопкаПоУмолчанию = ОбъектСтартован(Форма);
		
		Форма.Элементы.ФормаНастроитьОтложенныйСтарт.Доступность = Не Форма.Объект.Стартован;
		
		//Если Форма.Объект.ГлавнаяЗадача = Неопределено Или Форма.Объект.ГлавнаяЗадача.Пустая() Тогда
		//	Форма.Элементы.ГлавнаяЗадача.Гиперссылка = Ложь;
		//КонецЕсли;
		
		Если Не Форма.ИспользоватьПодчиненныеБизнесПроцессы Тогда
			Форма.Элементы.ГлавнаяЗадача.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	УстановитьДоступностьПроверяющего(Форма);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьДатуЗавершенияОтложенногоПроцесса(ПроверяемыйОбъект, Отказ)

	Если Не ЗначениеЗаполнено(ПроверяемыйОбъект.СрокИсполнения) Тогда
		Возврат;
	КонецЕсли;
	
	ДатаОтложенногоСтарта = БизнесПроцессыИЗадачиСервер.ДатаОтложенногоСтартаПроцесса(ПроверяемыйОбъект.Ссылка);
	
	Если ПроверяемыйОбъект.СрокИсполнения < ДатаОтложенногоСтарта Тогда
		Ошибки = Неопределено;
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
			Ошибки,
			"Объект.СрокИсполнения",
			НСтр("ru = 'Срок исполнения задания не может быть меньше даты отложенного старта.'"), "");
	КонецЕсли;

	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкуОтложенногоСтарта()

	Если КлючевыеРеквизитыФормыЗаполнены() Тогда
		БизнесПроцессыИЗадачиКлиент.НастроитьОтложенныйСтарт(Объект.Ссылка, Объект.СрокИсполнения);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция КлючевыеРеквизитыФормыЗаполнены()

	Если Объект.Стартован Тогда
		Возврат Истина;
	КонецЕсли;
	
	ОшибкиПользователю = Неопределено;
	ОчиститьСообщения();
	
	Если НЕ ЗначениеЗаполнено(Объект.Исполнитель) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
			ОшибкиПользователю,
			"Объект.Исполнитель",
			НСтр("ru = 'Поле ""Исполнитель"" не заполнено.'"),
			"");
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект.Наименование) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
			ОшибкиПользователю,
			"Объект.Наименование",
			НСтр("ru = 'Поле ""Задание"" не заполнено.'"),
			"");
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект.СрокИсполнения) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
			ОшибкиПользователю,
			"Объект.СрокИсполнения",
			НСтр("ru = 'Поле ""Срок"" исполнения не заполнено.'"),
			"");
	КонецЕсли;

	РеквизитыФормыНеЗаполнены = Ложь;
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(ОшибкиПользователю, РеквизитыФормыНеЗаполнены);
	
    Возврат Не РеквизитыФормыНеЗаполнены;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОбъектСтартован(Форма)
	Возврат Форма.Объект.Стартован ИЛИ Форма.Отложен;
КонецФункции

&НаСервере
Процедура УстановитьРеквизитыОтложенногоСтарта()

	ДатаОтложенногоСтарта = БизнесПроцессыИЗадачиСервер.ДатаОтложенногоСтартаПроцесса(Объект.Ссылка);
	Отложен = (ДатаОтложенногоСтарта <> '00010101');
	
КонецПроцедуры

&НаСервере
Процедура ВариантЗаполненияНаСервере()
	
	// Берем только основные
	МассивПС = Новый Массив;
	СтрокиТЧ = Объект.ПредметыСнабжения.НайтиСтроки(Новый Структура("Основной", Истина));
	
	Для каждого СтрокаТЧ Из СтрокиТЧ Цикл
		МассивПС.Добавить(СтрокаТЧ.СсылкаПС);
	КонецЦикла; 
	
	// Получаем таблицу ПС с учем флагов заполнения
	Если СУчетомСпецификации И НЕ РазвернутьДерево Тогда
		ТаблицаСпецификаций = ВзаимодействиеСРОЭ.ЗаполнитьТаблицуСпецификаций(МассивПС); 
	ИначеЕсли СУчетомСпецификации И РазвернутьДерево Тогда
		ТаблицаСпецификаций = ВзаимодействиеСРОЭ.ЗаполнитьТаблицуДереваСпецификаций(МассивПС); 
	Иначе
		ТаблицаСпецификаций = ВзаимодействиеСРОЭ.ЗаполнитьТаблицуДляВыгрузки(МассивПС);
	КонецЕсли; 
	
	ТаблицаСпецификаций.Колонки.Добавить("Характеристики");
	
	// Заполняем табличную часть
	ТаблЧастьПС = Объект.ПредметыСнабжения;
	ТаблЧастьПС.Очистить();
	
	Для каждого Стр Из ТаблицаСпецификаций Цикл
		
		Если НЕ СокрЛП(Стр.СсылкаПС.NSN) = "" Тогда
			Сообщить("Предмет снабжения """+Стр.СсылкаПС+""" не добавлен, т.к. у него заполнен ""NSN""");
			Продолжить;
		КонецЕсли; 
		
		ТекстСообщения = ""; ЕстьОшибки = Ложь;
		Если НЕ ЗначениеЗаполнено(Стр.Наименование) Тогда
			ТекстСообщения = "Наименование";
			ЕстьОшибки = Истина;
		КонецЕсли; 
		Если НЕ ЗначениеЗаполнено(Стр.Обозначение) Тогда
			ТекстСообщения = ?(ТекстСообщения="", "", ", ") + "Обозначение";
			ЕстьОшибки = Истина;
		КонецЕсли; 
		Если НЕ ЗначениеЗаполнено(Стр.КодОКПОПредприятияИзготовителя) Тогда
			ТекстСообщения = ?(ТекстСообщения="", "", ", ") + "ОКПО поставщика";
			ЕстьОшибки = Истина;
		КонецЕсли; 
		Если ЕстьОшибки Тогда
			Сообщить("Предмет снабжения """+Стр.СсылкаПС+""" не добавлен, т.к. у него не заполнены реквизиты: " + ТекстСообщения);
			Продолжить;
		КонецЕсли; 
		
		НовСтр = ТаблЧастьПС.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, Стр);
		
		// Собираем характеристики в формате: [Наименование характеристики] = [Значение] [Ед. изм.]; 
		СтрокаХар = "";
		Для каждого ТекХар Из Стр.СсылкаПС.Характеристики Цикл
			СтрокаХар = СтрокаХар + ?(СтрокаХар="", "",Символы.ПС) +Строка(ТекХар.Характеристика)+"-"+Строка(ТекХар.Значение)+" "+Строка(ТекХар.ЕдиницаИзмерения);
		КонецЦикла;
		НовСтр.Характеристики = СтрокаХар;
	КонецЦикла;
	
	ТаблЧастьПС.Сортировать("Наименование, Входимость");
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантЗаполненияПриИзменении(Элемент)
	
	ВариантЗаполненияНаСервере();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьИменаКолонокДляШапки()
	
	КолонкиМетаданные = Метаданные.БизнесПроцессы.ВзаимодействиеСРОЭ.ТабличныеЧасти.ПредметыСнабжения.Реквизиты;
	Массив = Новый Массив;
	Массив.Добавить(Новый Структура("Имя, Синоним", "НомерСтроки", "Строка"));
	//Сделаем шапку, из синонимов реквизитов ТЧ
	Для каждого Рекв Из КолонкиМетаданные Цикл
		Если Рекв.Имя = "Основной" ИЛИ Рекв.Имя = "СсылкаПС" Тогда
			Продолжить;
		КонецЕсли;
		Если Рекв.Имя = "NSN" Тогда // Дальше колонки не выгружаем
			Прервать;
		КонецЕсли; 
		Массив.Добавить(Новый Структура("Имя, Синоним", Рекв.Имя, Рекв.Синоним));
	КонецЦикла;
	
	Возврат Массив;
	
КонецФункции
 
&НаКлиенте
Процедура ВыгрузитьВФайл(ПутьКФайлу, Каталог = "")
	
	КолонкиМетаданные = ПолучитьИменаКолонокДляШапки();
	
	ТабличныйДокумент = РаботаСФайламиOffice.ПодготовитьТабличныйДокументВзаимодействиеСРЭО(КолонкиМетаданные, Объект.ПредметыСнабжения, Каталог);
	Попытка
		ТабличныйДокумент.ЗаписатьАсинх(ПутьКФайлу, ТипФайлаТабличногоДокумента.XLSX);
	Исключение
	    ОписаниеОшибки = ОписаниеОшибки();
		Сообщить("Документ Эксель не записан: " + ОписаниеОшибки);
	КонецПопытки;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьРасширениеФайла(Знач ИмяФайла)
	
	РасширениеФайла = "";
	МассивСтрок = СтрРазделить(ИмяФайла, ".", Ложь);
	Если МассивСтрок.Количество() > 1 Тогда
		РасширениеФайла = МассивСтрок[МассивСтрок.Количество() - 1];
	КонецЕсли;
	
	Возврат РасширениеФайла;
	
КонецФункции

&НаСервере
Функция ПолучитьПрисоединенныеФайлы(Ссылка)
	
	МассивФайлов = Новый Массив;
	
	ПрисоединенныеФайлы.ПолучитьПрикрепленныеФайлыКОбъекту(Ссылка, МассивФайлов);
	
	Возврат МассивФайлов;
	
КонецФункции
 

&НаСервере
Процедура ДобавитьФайлВПрисоединенныеФайлы(ПутьКФайлу, АдресВоВременномХранилище)
	
	ПолныйФайл= ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ПутьКФайлу);
	ИмяБезРасширения   = ПолныйФайл.ИмяБезРасширения;
	РасширениеБезТочки = СтрЗаменить(ПолныйФайл.Расширение, ".", "");
	
	ПараметрыФайла = Новый Структура;
	ПараметрыФайла.Вставить("ВладелецФайлов",              Объект.Ссылка);
	ПараметрыФайла.Вставить("Автор",                       ПараметрыСеанса.ТекущийПользователь);
	ПараметрыФайла.Вставить("ИмяБезРасширения",            ИмяБезРасширения);
	ПараметрыФайла.Вставить("РасширениеБезТочки",          РасширениеБезТочки);
	ПараметрыФайла.Вставить("ВремяИзменения",              Неопределено);
	ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", Неопределено);
	
	ПрисоединенныеФайлы.ДобавитьПрисоединенныйФайл(ПараметрыФайла, АдресВоВременномХранилище, "", "");
	
КонецПроцедуры

&НаСервере
Функция СтартоватьБизнецПроцесс()
	
	БПОбъект = ДанныеФормыВЗначение(Объект, Тип("БизнесПроцессОбъект.ВзаимодействиеСРОЭ"));
	
	Попытка
		БПОбъект.Записать();
		БПОбъект.Старт();
		
		ЗначениеВДанныеФормы(БПОбъект, Объект);
		
		Рез = Истина;
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		Рез = Ложь;
	КонецПопытки;
	                 
	Возврат Рез;
	
КонецФункции

&НаКлиенте
Процедура ВыгрузитьВФайлИСтартовать(Команда)
	
	Если Объект.ПредметыСнабжения.Количество() = 0 Тогда
		ПоказатьПредупреждение(, "Нечего выгружать", 3);
		Возврат;
	КонецЕсли; 
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	Фильтр = "Табличный документ(*.xlsx)|*.xlsx|Табличный документ(*.xls)|*.xls";
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = "Выберите файл";
	ДиалогОткрытияФайла.Показать(Новый ОписаниеОповещения("ВыгрузитьВФайлИСтартоватьЗавершение", ЭтотОбъект, Новый Структура("ДиалогОткрытияФайла", ДиалогОткрытияФайла)));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьВФайлИСтартоватьЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	ДиалогОткрытияФайла = ДополнительныеПараметры.ДиалогОткрытияФайла;
	
	
	Если (ВыбранныеФайлы <> Неопределено) Тогда
		ПолныйПутьКФайлу = ДиалогОткрытияФайла.ПолноеИмяФайла;
		Каталог 		 = ДиалогОткрытияФайла.Каталог;
	КонецЕсли;
	
	Если ПолныйПутьКФайлу = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	// Сохранение на диск
	ВыгрузитьВФайл(ПолныйПутьКФайлу, Каталог);
	
	// Старт
	БПЗаписан = СтартоватьБизнецПроцесс();
	
	Если БПЗаписан Тогда
		
		// Сохранение в присоединенные файлы
		АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ПолныйПутьКФайлу));
		
		// Добавляем присоединенный файл
		ДобавитьФайлВПрисоединенныеФайлы(ПолныйПутьКФайлу, АдресВоВременномХранилище);
		
		// Снимаем доступность у кнопки, чтобы ещё раз не выгружать
		Элементы.ФормаВыгрузитьВФайлИСтартовать.Доступность = Ложь;
		
	КонецЕсли; 
	
	ИнициализацияФормы();

КонецПроцедуры

&НаКлиенте
Процедура ПредметыСнабженияПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.Основной = Истина;
		ВариантЗаполненияНаСервере();
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СУчетомСпецификацииПриИзменении(Элемент)
	
	Если СУчетомСпецификации Тогда
		Элементы.РазвернутьДерево.Доступность = Истина;
	Иначе
		Элементы.РазвернутьДерево.Доступность = Ложь;
		РазвернутьДерево = Ложь;
	КонецЕсли; 
	
	ВариантЗаполненияНаСервере();	
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьДеревоПриИзменении(Элемент)
	
	ВариантЗаполненияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если Объект.ПредметыСнабжения.Количество() > 0 Тогда
		ОповещениеВопрос = Новый ОписаниеОповещения("ПоказатьВопросПродолжение", ЭтотОбъект);
		ПоказатьВопрос(ОповещениеВопрос, "Очистить табличную часть?", РежимДиалогаВопрос.ДаНет);
	Иначе
		ЗаполнитьТабличнуюЧасть();
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВопросПродолжение(Результат, ДопПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Объект.ПредметыСнабжения.Очистить();
	КонецЕсли; 
	
	ЗаполнитьТабличнуюЧасть();
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТабличнуюЧасть()
	
	ПарМножественныйВыбор = Истина;
	
	Если Объект.ВариантЗаполнения = 1 Тогда
		ФормаВыбора = "Справочник.КаталогПредметовСнабжения.Форма.ФормаСписка";
	ИначеЕсли Объект.ВариантЗаполнения = 2 Тогда
		ФормаВыбора = "Документ.Заявка.Форма.ФормаСписка";
	ИначеЕсли Объект.ВариантЗаполнения = 3 Тогда
		ФормаВыбора = "Документ.Контракт.Форма.ФормаСписка";;
	ИначеЕсли Объект.ВариантЗаполнения = 4 Тогда
		ФормаВыбора = "Справочник.Заказы.Форма.ФормаВыбора";
		ПарМножественныйВыбор = Ложь;
	Иначе
		Возврат;
	КонецЕсли; 
	
	ОповещениеВыбора = Новый ОписаниеОповещения("ЗаполнитьПродолжение", ЭтотОбъект);
	
	ПараметрыПодбора = Новый Структура("РежимВыбора, МножественныйВыбор", Истина, ПарМножественныйВыбор);
	
	Возращ = ОткрытьФорму(ФормаВыбора, ПараметрыПодбора, ЭтаФорма,,,, ОповещениеВыбора);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПредметыСнабженияПоКораблю(Корабль)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СтруктураЗаказаПоКомплектующимИзделиямИЗИП.ПредметСнабжения.Ссылка КАК ПредметСнабженияСсылка
	|ИЗ
	|	Справочник.СтруктураЗаказаПоКомплектующимИзделиямИЗИП КАК СтруктураЗаказаПоКомплектующимИзделиямИЗИП
	|ГДЕ
	|	СтруктураЗаказаПоКомплектующимИзделиямИЗИП.Владелец В(&Владелец)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПредметСнабженияСсылка
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.УстановитьПараметр("Владелец", Корабль);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ПредметСнабженияСсылка");
	
КонецФункции

&НаСервере
Функция ЗаполнитьПродолжениеНаСервере(Массив)
	
	МассивПС = Новый Массив;
	Если Объект.ВариантЗаполнения = 1 Тогда
		МассивПС = Массив;
	ИначеЕсли Объект.ВариантЗаполнения = 2 Тогда
		Для каждого Док Из Массив Цикл
			Для каждого СтрТЧ Из Док.Спецификация Цикл
				МассивПС.Добавить(СтрТЧ.ПредметСнабжения);
			КонецЦикла; 
		КонецЦикла; 
	ИначеЕсли Объект.ВариантЗаполнения = 3 Тогда
		Для каждого Док Из Массив Цикл
			Для каждого СтрТЧ Из Док.ПредметыСнабжения Цикл
				МассивПС.Добавить(СтрТЧ.ПредметСнабжения);
			КонецЦикла; 
		КонецЦикла; 
	ИначеЕсли Объект.ВариантЗаполнения = 4 Тогда
		 МассивПС = ПолучитьПредметыСнабженияПоКораблю(Массив);
	КонецЕсли;
	
	Для каждого Элем Из МассивПС Цикл
		НовСтр = Объект.ПредметыСнабжения.Добавить();
		НовСтр.СсылкаПС = Элем;
		НовСтр.Основной = Истина;
	КонецЦикла; 
	
	ВариантЗаполненияНаСервере();
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьПродолжение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	ЗаполнитьПродолжениеНаСервере(РезультатЗакрытия);
	
КонецПроцедуры
 

#КонецОбласти
