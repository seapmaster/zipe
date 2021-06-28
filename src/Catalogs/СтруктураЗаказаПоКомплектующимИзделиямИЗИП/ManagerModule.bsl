/////////////////////////////////////////////
// ОБРАБОТЧИКИ МОДУЛЯ МЕНЕДЖЕРА

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" Тогда
		
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = ?(Параметры.Ключ.Тип = Справочники.ТипыУзловЭлектроннойСтруктурыКомплектующихИзделийИЗИПКорабля.Группа, "ФормаГруппы", "ФормаИзделия");
		
	КонецЕсли;
	
КонецПроцедуры

Функция ВыполнитьИтерациюПоискаИзделияВерхнегоУровня(Знач ТекущийЭлемент, Знач Изделие)
	Если ТекущийЭлемент.Тип = Справочники.ТипыУзловЭлектроннойСтруктурыКомплектующихИзделийИЗИПКорабля.Изделие Тогда
		Изделие = ТекущийЭлемент;
	КонецЕсли; // Если ТекущийЭлемент.Тип = Справочники.ТипыУзловЭлектроннойСтруктурыКомплектующихИзделийИЗИПКорабля.Изделие Тогда
	
	Если Не ЗначениеЗаполнено(ТекущийЭлемент.Родитель) Тогда
		Возврат Изделие;
	КонецЕсли; // Если Не ЗначениеЗаполнено(ТекущийЭлемент.Родитель) Тогда	
	ТекущийЭлемент = ТекущийЭлемент.Родитель;                             	
	
	Возврат ВыполнитьИтерациюПоискаИзделияВерхнегоУровня(ТекущийЭлемент, Изделие);
КонецФункции // ВыполнитьИтерациюПоиска

	
/////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция СсылкаЭтоИзделие(Элемент) Экспорт
	Возврат (Элемент.Тип = Справочники.ТипыУзловЭлектроннойСтруктурыКомплектующихИзделийИЗИПКорабля.Изделие)
КонецФункции

Функция ЕстьПодчиненныеГруппы(ТекДанные) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СтруктураЗаказаПоКомплектующимИзделиямИЗИП.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СтруктураЗаказаПоКомплектующимИзделиямИЗИП КАК СтруктураЗаказаПоКомплектующимИзделиямИЗИП
	|ГДЕ
	|	СтруктураЗаказаПоКомплектующимИзделиямИЗИП.Тип = ЗНАЧЕНИЕ(Справочник.ТипыУзловЭлектроннойСтруктурыКомплектующихИзделийИЗИПКорабля.Группа)
	|	И СтруктураЗаказаПоКомплектующимИзделиямИЗИП.Ссылка В ИЕРАРХИИ(&Родитель)
	|	И НЕ СтруктураЗаказаПоКомплектующимИзделиямИЗИП.Ссылка = &Родитель";
	
	Запрос.УстановитьПараметр("Родитель", ТекДанные);

	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли; 
	
КонецФункции

Функция ЭтоЗИП(Ссылка) Экспорт
	
	Возврат Ссылка.ЗИП;
	
КонецФункции

Функция ЕстьВОчередиНаИзменение(Ссылка) Экспорт
	
	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//"ВЫБРАТЬ
	//|	СпецификацииПредметовСнабженияОчередьИзменений.ПредметСнабжения КАК ПредметСнабжения
	//|ИЗ
	//|	РегистрСведений.СпецификацииПредметовСнабженияОчередьИзменений КАК СпецификацииПредметовСнабженияОчередьИзменений
	//|ГДЕ
	//|	СпецификацииПредметовСнабженияОчередьИзменений.ПредметСнабжения = &ПредметСнабжения";
	//
	//Запрос.УстановитьПараметр("ПредметСнабжения", Ссылка.ПредметСнабжения);
	//
	//Выборка = Запрос.Выполнить().Выбрать();
	//
	//Если Выборка.Следующий() Тогда
	//	Возврат Истина;
	//Иначе
	//	Возврат Ложь;
	//КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	АктуализацияСтруктурыПС.ПредметСнабжения КАК ПредметСнабжения
	|ИЗ
	|	РегистрСведений.АктуализацияСтруктурыПС КАК АктуализацияСтруктурыПС
	|ГДЕ
	|	АктуализацияСтруктурыПС.ПредметСнабжения = &ПредметСнабжения";
	
	Запрос.УстановитьПараметр("ПредметСнабжения", Ссылка.ПредметСнабжения);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли; 

КонецФункции
 
Функция ПолучитьИзделие(ПредметСнабжения, Корабли) Экспорт	
	Результат 		= Неопределено;
	Если Не ЗначениеЗаполнено(ПредметСнабжения) Тогда
		Возврат Результат;
	КонецЕсли; // Если Не ЗначениеЗаполнено(ПредметСнабжения) Тогда
	
	Запрос 			= Новый Запрос;
	Запрос.Текст 	= "ВЫБРАТЬ
	             	  |	СтруктураЗаказаПоКомплектующимИзделиямИЗИП.Ссылка КАК Изделие,
	             	  |	ЕСТЬNULL(ОписанияИерархииЭлементовСтруктурыЗаказовПоКомплектующимИзделиямИЗИП.ОписаниеИерархии, """") КАК ОписаниеИерархии,
	             	  |	СтруктураЗаказаПоКомплектующимИзделиямИЗИП.Владелец КАК Корабль,
	             	  |	СтруктураЗаказаПоКомплектующимИзделиямИЗИП.Владелец.Владелец КАК Проект
	             	  |ИЗ
	             	  |	Справочник.СтруктураЗаказаПоКомплектующимИзделиямИЗИП КАК СтруктураЗаказаПоКомплектующимИзделиямИЗИП
	             	  |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОписанияИерархииЭлементовСтруктурыЗаказовПоКомплектующимИзделиямИЗИП КАК ОписанияИерархииЭлементовСтруктурыЗаказовПоКомплектующимИзделиямИЗИП
	             	  |		ПО СтруктураЗаказаПоКомплектующимИзделиямИЗИП.Ссылка = ОписанияИерархииЭлементовСтруктурыЗаказовПоКомплектующимИзделиямИЗИП.ЭлементСтруктуры
	             	  |ГДЕ
	             	  |	СтруктураЗаказаПоКомплектующимИзделиямИЗИП.Владелец В(&Корабли)
	             	  |	И НЕ СтруктураЗаказаПоКомплектующимИзделиямИЗИП.ПометкаУдаления
	             	  |	И СтруктураЗаказаПоКомплектующимИзделиямИЗИП.ПредметСнабжения = &ПредметСнабжения";
	Запрос.УстановитьПараметр("ПредметСнабжения", ПредметСнабжения);
	Запрос.УстановитьПараметр("Корабли", Корабли);
	Выборка 		= Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат 	= Новый Структура("Изделие, Описание", 
										Выборка.Изделие, 
										"" 	+ Выборка.Проект 
											+ "/" 
											+ Выборка.Корабль 
											+ "/" 
											+ Выборка.ОписаниеИерархии);
	КонецЕсли; // Если Выборка.Следующий() Тогда
	
	Возврат Результат;
КонецФункции // ПолучитьИзделие

Функция ПолучитьСписок(ПредметСнабжения, Корабли) Экспорт
	Результат		= Новый СписокЗначений;
	Запрос			= Новый Запрос;
	Запрос.Текст 	= "ВЫБРАТЬ
	             	  |	СтруктураЗаказаПоКомплектующимИзделиямИЗИП.Ссылка КАК Изделие,
	             	  |	ЕСТЬNULL(ОписанияИерархииЭлементовСтруктурыЗаказовПоКомплектующимИзделиямИЗИП.ОписаниеИерархии, """") КАК ОписаниеИерархии,
	             	  |	СтруктураЗаказаПоКомплектующимИзделиямИЗИП.Владелец КАК Корабль,
	             	  |	СтруктураЗаказаПоКомплектующимИзделиямИЗИП.Владелец.Владелец КАК Проект
	             	  |ИЗ
	             	  |	Справочник.СтруктураЗаказаПоКомплектующимИзделиямИЗИП КАК СтруктураЗаказаПоКомплектующимИзделиямИЗИП
	             	  |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОписанияИерархииЭлементовСтруктурыЗаказовПоКомплектующимИзделиямИЗИП КАК ОписанияИерархииЭлементовСтруктурыЗаказовПоКомплектующимИзделиямИЗИП
	             	  |		ПО СтруктураЗаказаПоКомплектующимИзделиямИЗИП.Ссылка = ОписанияИерархииЭлементовСтруктурыЗаказовПоКомплектующимИзделиямИЗИП.ЭлементСтруктуры
	             	  |ГДЕ
	             	  |	СтруктураЗаказаПоКомплектующимИзделиямИЗИП.Владелец В(&Корабли)
	             	  |	И НЕ СтруктураЗаказаПоКомплектующимИзделиямИЗИП.ПометкаУдаления
	             	  |	И СтруктураЗаказаПоКомплектующимИзделиямИЗИП.ПредметСнабжения = &ПредметСнабжения";
	Запрос.УстановитьПараметр("ПредметСнабжения", ПредметСнабжения);
	Запрос.УстановитьПараметр("Корабли", Корабли);
	Выборка 		= Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат.Добавить(Выборка.Изделие,  "" 	+ Выборка.Изделие
													+ " - "
													+ Выборка.Проект 
													+ "/" 
													+ Выборка.Корабль 
													+ "/" 
													+ Выборка.ОписаниеИерархии);
	КонецЕсли; // Если Выборка.Следующий() Тогда
	
	Возврат Результат;
КонецФункции // ПолучитьСписок

Функция ПолучитьИзделиеВерхнегоУровня(ЭлементСтруктуры) Экспорт	
	
	Возврат ВыполнитьИтерациюПоискаИзделияВерхнегоУровня(ЭлементСтруктуры, Неопределено);
КонецФункции // ПолучитьИзделиеВерхнегоУровня
