/////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Область ПолучениеПочты

Функция СохранитьСообщение(Сообщение, Получатель)
	Результат = Неопределено;
	
	Для Каждого Идентификатор Из Сообщение.Идентификатор Цикл
		Если Документы.ПочтовоеСообщение.СообщениеСуществует(Идентификатор) Тогда
			Возврат Результат;
		КонецЕсли; // Если Документы.ПочтовоеСообщение.СообщениеСуществует(Идентификатор) Тогда		
	КонецЦикла; // Для Каждого Идентификатор Из Сообщение.Идентификатор Цикл
	
	НачатьТранзакцию();
	// Создаем почтовое сообщение
	Документ 				= Документы.ПочтовоеСообщение.СоздатьДокумент();
	Документ.Дата 			= ТекущаяДата();
	Документ.Отправитель 	= Сообщение.Отправитель;
	Документ.Получатель 	= Получатель;
	Документ.Заголовок		= Сообщение.Тема;
	Для Каждого Идентификатор Из Сообщение.Идентификатор Цикл
		Документ.ИдентификаторСообщения = Идентификатор;
	КонецЦикла; // Для Каждого Идентификатор Из Сообщение.Идентификатор Цикл
	
	Попытка		
		Документ.Записать();
		
		// Регистрируем сообщение для обработки
		РегистрыСведений.ПочтовыеСообщенияВходящие.ЗарегистрироватьСообщение(Документ.Ссылка);
		
		// Сохраняем вложение
		Для Каждого Вложение Из Сообщение.Вложения Цикл
			ПрисоединенныеФайлы.ДобавитьФайл(Документ.Ссылка, Вложение.Ключ, ,,, ПоместитьВоВременноеХранилище(Вложение.Значение));
		КонецЦикла; // Для Каждого Вложение Из Сообщение.Вложения Цикл
		ЗафиксироватьТранзакцию();
		Результат 	= Истина;
	Исключение
		ОтменитьТранзакцию();
		Результат 	= Ложь;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось сохранить сообщение: " + ОписаниеОшибки());
	КонецПопытки;
	
	Возврат Результат;
КонецФункции // СохранитьСоощение

#КонецОбласти

#Область Сервис

Процедура ДобавитьЭлементXML(Запись, Имя, Значение)
	Запись.ЗаписатьНачалоЭлемента(Имя);	
	Запись.ЗаписатьТекст(Строка(Значение));
	Запись.ЗаписатьКонецЭлемента();
КонецПроцедуры // ДобавитьЭлементXML 

Процедура СохранитьВложение(ПочтовоеСообщение, ИмяФайла)
	ПараметрыФайла = Новый Структура;
	ПараметрыФайла.Вставить("ВладелецФайлов",              ПочтовоеСообщение);
	ПараметрыФайла.Вставить("Автор",                       Пользователи.ТекущийПользователь());
	ПараметрыФайла.Вставить("ИмяБезРасширения",            "SearchRequest");
	ПараметрыФайла.Вставить("РасширениеБезТочки",          "xml");
	ПараметрыФайла.Вставить("ВремяИзменения",              ТекущаяДата());
	ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", ТекущаяУниверсальнаяДата());
	
	ПрисоединенныеФайлы.ДобавитьПрисоединенныйФайл(ПараметрыФайла, ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ИмяФайла)));  
КонецПроцедуры // СохранитьВложение

Процедура ДобавитьВОчередьНаОтправку(ПочтовоеСообщение)
	Запись 						= РегистрыСведений.ПочтовыеСообщенияИсходящие.СоздатьМенеджерЗаписи();
	Запись.ПочтовоеСообщение 	= ПочтовоеСообщение;
	Запись.Записать();
КонецПроцедуры // ДобавитьВОчередьНаОтправку

#КонецОбласти

#Область СформироватьЗапросНаПоиск

Функция СоздатьПочтовоеСообщениеПоиск(Параметры)
	ПочтовоеСообщениеОбъект = Документы.ПочтовоеСообщение.СоздатьДокумент();
	ПочтовоеСообщениеОбъект.Дата 			= ТекущаяДата();
	ПочтовоеСообщениеОбъект.Отправитель 	= Справочники.УчетныеЗаписиЭлектроннойПочты.ОбменСНСИ;
	ПочтовоеСообщениеОбъект.Ответственный 	= Пользователи.ТекущийПользователь();
	ПочтовоеСообщениеОбъект.Получатель 		= Параметры.Получатель;
	
	ПочтовоеСообщениеОбъект.Заголовок 		= "Запрос на поиск";
	ТекстСообщения = "Запрос на поиск предмета снабжения:";
	Для Каждого ЭлементПоиска Из Параметры.СтруктураПоиска Цикл
		ТекстСообщения = ТекстСообщения + Символы.ПС 
										+ СтрШаблон("Код [%1]Наименование: [%2] Обозначение: [%3] Значение поиска: [%4]", 
										    ЭлементПоиска.ПредметСнабжения.Код,
											ЭлементПоиска.ПредметСнабжения.Наименование,
											ЭлементПоиска.ПредметСнабжения.Обозначение,
											ЭлементПоиска.Значение);
	КонецЦикла; // Для Каждого ПредметСнабжения из Параметры.ПредметыСнабжения Цикл
	
	ПочтовоеСообщениеОбъект.ТекстСообщения 	= ТекстСообщения;
	ПочтовоеСообщениеОбъект.Записать();
	Возврат ПочтовоеСообщениеОбъект.Ссылка;
КонецФункции // СоздатьПочтовоеСообщение

Функция СформироватьФайлЗапросаПоиск(Параметры)
	ИмяФайла 		= ПолучитьИмяВременногоФайла("xml");
	ЗаписьXML 		= Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(ИмяФайла, "UTF-8");
	// Записать директиву.
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("SearchRequest");
	// AbonentId
	ДобавитьЭлементXML(ЗаписьXML, "AbonentId", Параметры.ИдентификаторАбонента);
	
	Для Каждого ЭлементПоиска Из Параметры.СтруктураПоиска Цикл
		//SearchRequestItem
		ЗаписьXML.ЗаписатьНачалоЭлемента("SearchRequestItem");
		ДобавитьЭлементXML(ЗаписьXML, "ItemID", ЭлементПоиска.ПредметСнабжения.УникальныйИдентификатор());
		ДобавитьЭлементXML(ЗаписьXML, "Query", 	ЭлементПоиска.Значение);		
		ЗаписьXML.ЗаписатьКонецЭлемента(); // SearchRequestItem
	КонецЦикла; // Для Каждого ЭлементПоиска Из Параметры.СтруктураПоиска Цикл
	ЗаписьXML.ЗаписатьКонецЭлемента(); // SearchRequest
	ЗаписьXML.Закрыть();
	
	Возврат ИмяФайла;
КонецФункции // СформироватьФайлЗапроса

#КонецОбласти

#Область СформироватьЗапросНаПрисвоениеКода

Функция СоздатьПочтовоеСообщениеПрисвоениеКода(Параметры)
	ПочтовоеСообщениеОбъект = Документы.ПочтовоеСообщение.СоздатьДокумент();
	ПочтовоеСообщениеОбъект.Дата 			= ТекущаяДата();
	ПочтовоеСообщениеОбъект.Отправитель 	= Справочники.УчетныеЗаписиЭлектроннойПочты.ОбменСНСИ;
	ПочтовоеСообщениеОбъект.Ответственный 	= Пользователи.ТекущийПользователь();
	ПочтовоеСообщениеОбъект.Получатель 		= Параметры.Получатель;
	
	ПочтовоеСообщениеОбъект.Заголовок 		= "Запрос на присвоение кода";
	ТекстСообщения = "Запрос на присвоение кода предмету снабжения:";
	Для Каждого ЭлементСтруктуры Из Параметры.СтруктураСоздания Цикл
		ТекстСообщения = ТекстСообщения + Символы.ПС 
										+ СтрШаблон("Код [%1] Наименование: [%2] Обозначение: [%3]", 
										    ЭлементСтруктуры.ПредметСнабжения.Код,
											ЭлементСтруктуры.ПредметСнабжения.Наименование,
											ЭлементСтруктуры.ПредметСнабжения.Обозначение);
	КонецЦикла; // Для Каждого ЭлементСтруктуры Из Параметры.СтруктураСоздания Цикл
	
	ПочтовоеСообщениеОбъект.ТекстСообщения 	= ТекстСообщения;
	ПочтовоеСообщениеОбъект.Записать();
	Возврат ПочтовоеСообщениеОбъект.Ссылка;
КонецФункции // СоздатьПочтовоеСообщениеПрисвоениеКода

Функция СформироватьФайлЗапросаПрисвоениеКода(Параметры)
	ИмяФайла 		= ПолучитьИмяВременногоФайла("xml");
	ЗаписьXML 		= Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(ИмяФайла, "UTF-8");
	// Записать директиву.
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("CreateRequest");
	// AbonentId
	ДобавитьЭлементXML(ЗаписьXML, "AbonentId", Параметры.ИдентификаторАбонента);
	
	Для Каждого ЭлементСтруктуры Из Параметры.СтруктураСоздания Цикл
		//CreateRequestItem
		ЗаписьXML.ЗаписатьНачалоЭлемента("CreateRequestItem");
		ДобавитьЭлементXML(ЗаписьXML, "ItemID", ЭлементСтруктуры.ПредметСнабжения.УникальныйИдентификатор());
		ДобавитьЭлементXML(ЗаписьXML, "Code", 	ЭлементСтруктуры.Обозначение);		
		ДобавитьЭлементXML(ЗаписьXML, "Name", 	ЭлементСтруктуры.ПредметСнабжения.Наименование);		
		
		Если ЭлементСтруктуры.Свойство("Класс") Тогда
			// Characteristic
			ЗаписьXML.ЗаписатьНачалоЭлемента("Characteristic");
			ДобавитьЭлементXML(ЗаписьXML, "Name", 	"Класс");		
			ДобавитьЭлементXML(ЗаписьXML, "Value", 	ЭлементСтруктуры.Класс);		
			ЗаписьXML.ЗаписатьКонецЭлемента(); // Characteristic
		КонецЕсли; // Если ЭлементСтруктуры.Свойство("Класс") Тогда
		
		ЗаписьXML.ЗаписатьКонецЭлемента(); // CreateRequestItem
	КонецЦикла; // Для Каждого ЭлементСтруктуры Из Параметры.СтруктураСоздания Цикл
	ЗаписьXML.ЗаписатьКонецЭлемента(); // CreateRequest
	ЗаписьXML.Закрыть();
	
	Возврат ИмяФайла;
КонецФункции // СформироватьФайлЗапросаПрисвоениеКода

#КонецОбласти

#Область ОбработкаПочты

Процедура ОбработатьПочтовоеСообщение(ПочтовоеСообщение)
	Вложения = Справочники.ПочтовоеСообщениеПрисоединенныеФайлы.ПолучитьВложения(ПочтовоеСообщение);
	Если Вложения.Количество() = 0 Тогда
		РегистрыСведений.ПочтовыеСообщенияВходящие.УстановитьОтметкуОбработки(ПочтовоеСообщение);
		Возврат;
	КонецЕсли; // Если Вложения.Количество() = 0 Тогда
	
	Для Каждого Вложение Из Вложения Цикл
		Если Не Вложение.Расширение = "xml" Тогда
			Продолжить;
		КонецЕсли; // Если Не Вложаение.Расширение = "xml" Тогда
		
		Попытка
			ОбработатьВложение(ПочтовоеСообщение, Вложение);
		Исключение
			РегистрыСведений.ПочтовыеСообщенияВходящие.УстановитьОтметкуОбработки(ПочтовоеСообщение, ОписаниеОшибки());
			Возврат;
		КонецПопытки;		
	КонецЦикла; // Для Каждого Вложение Из Вложения Цикл
	
	РегистрыСведений.ПочтовыеСообщенияВходящие.УстановитьОтметкуОбработки(ПочтовоеСообщение);
КонецПроцедуры // ОбработатьПочтовоеСообщение

Функция ОбработатьВложение(ПочтовоеСообщение, Вложение)
	ИмяФайла 	= ПолучитьИмяВременногоФайла("xml");
	ДанныеФайла = ПрисоединенныеФайлы.ПолучитьДвоичныеДанныеФайла(Вложение);	
	ДанныеФайла.Записать(ИмяФайла);
	
	РазобратьXML(ПочтовоеСообщение, ИмяФайла);
	УдалитьФайлы(ИмяФайла);
КонецФункции // ОбработатьВложение

Функция РазобратьXML(ПочтовоеСообщение, ИмяФайла)
	Результат 	= Ложь;
	
	Чтение 		= Новый ЧтениеXML;
	Чтение.ОткрытьФайл(ИмяФайла);
	Объект 		= ФабрикаXDTO.ПрочитатьXML(Чтение);
	Если Не Объект.Свойства().Получить("SearchResponseItem") = Неопределено Тогда
		SearchResponseItem(ПочтовоеСообщение, Объект);
		Результат = Истина;
	ИначеЕсли Не Объект.Свойства().Получить("CreateResponseItem") = Неопределено Тогда
		CreateResponseItem(ПочтовоеСообщение, Объект);
		Результат = Истина;
	КонецЕсли; // Если Объект.Свойства().Получить("type") = Неопределено Тогда 
	
	
	Возврат Результат;
КонецФункции // РазобратьXML

Функция SearchResponseItem(ПочтовоеСообщение, Объект)
	Результат = Истина;
	Если ТипЗнч(Объект.SearchResponseItem) = Тип("СписокXDTO") Тогда
		Ответы = Объект.SearchResponseItem;
	Иначе
		Ответы = Новый Массив;
		Ответы.Добавить(Объект.SearchResponseItem);
	КонецЕсли; // Если ТипЗнч(Объект.SearchResponseItem) = Тип("СписокXDTO") Тогда
	
	Для Каждого Ответ Из Ответы Цикл
		ОбработатьОтветПоисковогоЗапроса(ПочтовоеСообщение, Ответ);
	КонецЦикла; // Для Каждого Ответ Из Ответы Цикл
	
	Возврат Результат;
КонецФункции // SearchResponseItem

Процедура ОбработатьОтветПоисковогоЗапроса(ПочтовоеСообщение, Объект)
	Если Объект.Свойства().Получить("SearchRequestItem") = Неопределено Тогда
		Возврат;
	КонецЕсли; // Если Объект.Свойства().Получить("SearchRequestItem") = Неопределено Тогда
	
	SearchRequestItem = Объект.SearchRequestItem;
	Если SearchRequestItem.Свойства().Получить("ItemId") = Неопределено Тогда
		Возврат;
	КонецЕсли; // Если SearchRequestItem.Свойства().Получить("ItemId") = Неопределено Тогда
	
	ПредметСнабжения = Справочники.КаталогПредметовСнабжения.ПолучитьСсылку(Новый УникальныйИдентификатор(SearchRequestItem.ItemId));
	Если Не ЗначениеЗаполнено(ПредметСнабжения) Тогда
		Возврат;
	КонецЕсли; // Если Не ЗначениеЗаполнено(ПредметСнабжения) Тогда
	
	Описание 			= "";
	СостояниеОбмена 	= Перечисления.СостоянияОбменаСНСИ.КодОСКНеНайден;
	
	//// Общее количество
	//TotalFoundCount 	= "";
	//Если Объект.Свойства().Получить("TotalFoundCount") = Неопределено Тогда
	//	Описание 		= "Не удалось обработать ответ";
	//Иначе
	//	TotalFoundCount = Объект.TotalFoundCount;
	//КонецЕсли; // Если Объект.Свойства().Получить("TotalFoundCount") = Неопределено Тогда
	
	// Код ОСК
	КодыОСК 			= Новый Массив;
	КодОСК				= "";
	
	Если Не Объект.Свойства().Получить("FoundItem") = Неопределено Тогда
		Если ТипЗнч(Объект.FoundItem) = Тип("ОбъектXDTO") Тогда
			НайденныеЭлементы = Новый Массив;
			НайденныеЭлементы.Добавить(Объект.FoundItem);
		Иначе
			НайденныеЭлементы = Объект.FoundItem;
		КонецЕсли; // Если ТипЗнч(Объект.FoundItem) = Тип("ОбъектXDTO") Тогда
		
		Для Каждого НайденныйЭлемент Из НайденныеЭлементы Цикл
			Если НайденныйЭлемент.Свойства().Получить("CodeOSK") = Неопределено Тогда
				Продолжить;
			КонецЕсли; // Если НайденныйЭлемент.Свойства().Получить("CodeOSK") = Неопределено Тогда
			
			CodeOSK = НайденныйЭлемент.CodeOSK;
			Если КодыОСК.Найти(CodeOSK) = Неопределено Тогда
				КодыОСК.Добавить(CodeOSK);
			КонецЕсли; // Если КодыОСК.Найти(CodeOSK) = Неопределено Тогда			
		КонецЦикла; // Для Каждого НайденныйЭлемент Из НайденныеЭлементы Цикл		
	КонецЕсли; // Если Не Объект.Свойства().Получить("FoundItem") = Неопределено Тогда
	
	Если КодыОСК.Количество() = 1 Тогда
		КодОСК = КодыОСК[0];
	КонецЕсли; // Если КодыОСК.Количество() = 1 Тогда
		
	Если ЗначениеЗаполнено(КодОСК) Тогда
		ПредметСнабженияОбъект 							= ПредметСнабжения.ПолучитьОбъект();
		ПредметСнабженияОбъект.НомерОСК 				= КодОСК;
		ПредметСнабженияОбъект.ОбменДанными.Загрузка 	= Истина;
		Попытка
			ПредметСнабженияОбъект.Записать();
			СостояниеОбмена 							= Перечисления.СостоянияОбменаСНСИ.КодОСКНайден;
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось установить код ОСК: " + ОписаниеОшибки());
		КонецПопытки;
	КонецЕсли; // Если ЗначениеЗаполнено(CodeOSK) И TotalFoundCount = 1 Тогда
	
	Если Не Объект.Свойства().Получить("Comment") = Неопределено Тогда
		Описание = Объект.Comment;
	КонецЕсли; // Если Не Объект.Свойства().Получить("Comment") = Неопределено Тогда
	
	// Сохраним результат
	Идентификатор = РегистрыСведений.ОтветыНСИ.ДобавитьЗапись(ПредметСнабжения, Перечисления.ТипыЗапросовКНСИ.Поиск, ПочтовоеСообщение, Описание);
	РегистрыСведений.ОбменСНСИ.ДобавитьЗапись(ПредметСнабжения, Идентификатор, СостояниеОбмена, КодОСК);
КонецПроцедуры // ОбработатьОтветПоисковогоЗапроса

Функция CreateResponseItem(ПочтовоеСообщение, Объект)
	Результат = Истина;
	Если ТипЗнч(Объект.CreateResponseItem) = Тип("СписокXDTO") Тогда
		Ответы = Объект.CreateResponseItem;
	Иначе
		Ответы = Новый Массив;
		Ответы.Добавить(Объект.CreateResponseItem);
	КонецЕсли; // Если ТипЗнч(Объект.CreateResponseItem) = Тип("СписокXDTO") Тогда
	
	Для Каждого Ответ Из Ответы Цикл
		ОбработатьОтветЗапросаНаприсвоениеКода(ПочтовоеСообщение, Ответ);
	КонецЦикла; // Для Каждого Ответ Из Ответы Цикл
	
	Возврат Результат;
КонецФункции // SearchResponseItem

Процедура ОбработатьОтветЗапросаНаприсвоениеКода(ПочтовоеСообщение, Объект)
	Если Объект.Свойства().Получить("CreateRequestItem") = Неопределено Тогда
		Возврат;
	КонецЕсли; // Если Объект.Свойства().Получить("CreateRequestItem") = Неопределено Тогда
	
	CreateRequestItem = Объект.CreateRequestItem;
	Если CreateRequestItem.Свойства().Получить("ItemId") = Неопределено Тогда
		Возврат;
	КонецЕсли; // Если CreateRequestItem.Свойства().Получить("ItemId") = Неопределено Тогда
	
	ПредметСнабжения = Справочники.КаталогПредметовСнабжения.ПолучитьСсылку(Новый УникальныйИдентификатор(CreateRequestItem.ItemId));
	Если Не ЗначениеЗаполнено(ПредметСнабжения) Тогда
		Возврат;
	КонецЕсли; // Если Не ЗначениеЗаполнено(ПредметСнабжения) Тогда
	
	
	// Код ОСК
	КодОСК				= "";
	Если Объект.Свойства().Получить("CreatedItem") = Неопределено Тогда
		Возврат;
	КонецЕсли; // Если Объект.Свойства().Получить("CreatedItem") = Неопределено Тогда
	Если Не Объект.CreatedItem.Свойства().Получить("CodeOSK") = Неопределено Тогда
		КодОСК = Объект.CreatedItem.CodeOSK;
	КонецЕсли; // Если Не Объект.CreatedItem.Свойства().Получить("CodeOSK") = Неопределено Тогда	
		
	Если ЗначениеЗаполнено(КодОСК) Тогда
		ПредметСнабженияОбъект 							= ПредметСнабжения.ПолучитьОбъект();
		ПредметСнабженияОбъект.НомерОСК 				= КодОСК;
		ПредметСнабженияОбъект.ОбменДанными.Загрузка 	= Истина;
		Попытка
			ПредметСнабженияОбъект.Записать();
			СостояниеОбмена 							= Перечисления.СостоянияОбменаСНСИ.КодОСКПрисвоен;
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось установить код ОСК: " + ОписаниеОшибки());
		КонецПопытки;
	КонецЕсли; // Если ЗначениеЗаполнено(CodeOSK) И TotalFoundCount = 1 Тогда
	
	
	// Сохраним результат
	Идентификатор = РегистрыСведений.ОтветыНСИ.ДобавитьЗапись(ПредметСнабжения, Перечисления.ТипыЗапросовКНСИ.Создание, ПочтовоеСообщение);
	РегистрыСведений.ОбменСНСИ.ДобавитьЗапись(ПредметСнабжения, Идентификатор, СостояниеОбмена, КодОСК);
КонецПроцедуры // ОбработатьОтветЗапросаНаприсвоениеКода

#КонецОбласти

/////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИ

Функция СформироватьЗапросНаПоиск(СтруктураПоиска) Экспорт
	Результат 						= Истина;
	Параметры 						= Новый Структура;
	Параметры.Вставить("Получатель", 			Справочники.Настройки.ОбменНСИ_ПолучательПочтовыхСообщений());
	Параметры.Вставить("ИдентификаторАбонента", Справочники.Настройки.ОбменНСИ_ПолучитьИдентификаторАбонента());
	Параметры.Вставить("СтруктураПоиска", 		СтруктураПоиска);
	
	НачатьТранзакцию();
	Попытка
		ПочтовоеСообщение 	= СоздатьПочтовоеСообщениеПоиск(Параметры);
		ИмяФайлаЗапроса	 	= СформироватьФайлЗапросаПоиск(Параметры);
		СохранитьВложение(ПочтовоеСообщение, ИмяФайлаЗапроса);			
		ДобавитьВОчередьНаОтправку(ПочтовоеСообщение);	
		Для Каждого ЭлементПоиска Из СтруктураПоиска Цикл
			Идентификатор 		= РегистрыСведений.ЗапросыКНСИ.ДобавитьЗапись(ЭлементПоиска.ПредметСнабжения, Перечисления.ТипыЗапросовКНСИ.Поиск, ПочтовоеСообщение);
			РегистрыСведений.ОбменСНСИ.ДобавитьЗапись(ЭлементПоиска.ПредметСнабжения, Идентификатор, Перечисления.СостоянияОбменаСНСИ.ЗапросНаПоискСформирован);
		КонецЦикла; // Для Каждого ЭлементПоиска Из СтруктураПоиска Цикл
		ЗафиксироватьТранзакцию();
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось сформировать запрос: " + ОписаниеОшибки());
		Результат 				= Ложь;
		ОтменитьТранзакцию();
	КонецПопытки;
	
	Возврат Результат;
КонецФункции // СформироватьЗапросНаПоиск

Функция СформироватьЗапросНаПрисвоениеКода(СтруктураСоздания) Экспорт
	Результат 						= Истина;
	Параметры 						= Новый Структура;
	Параметры.Вставить("Получатель", 			Справочники.Настройки.ОбменНСИ_ПолучательПочтовыхСообщений());
	Параметры.Вставить("ИдентификаторАбонента", Справочники.Настройки.ОбменНСИ_ПолучитьИдентификаторАбонента());
	Параметры.Вставить("СтруктураСоздания", 	СтруктураСоздания);
	
	НачатьТранзакцию();
	Попытка
		ПочтовоеСообщение 	= СоздатьПочтовоеСообщениеПрисвоениеКода(Параметры);
		ИмяФайлаЗапроса	 	= СформироватьФайлЗапросаПрисвоениеКода(Параметры);
		СохранитьВложение(ПочтовоеСообщение, ИмяФайлаЗапроса);			
		ДобавитьВОчередьНаОтправку(ПочтовоеСообщение);	
		Для Каждого ЭлементСтруктуры Из СтруктураСоздания Цикл
			Идентификатор 		= РегистрыСведений.ЗапросыКНСИ.ДобавитьЗапись(ЭлементСтруктуры.ПредметСнабжения, Перечисления.ТипыЗапросовКНСИ.Создание, ПочтовоеСообщение);
			РегистрыСведений.ОбменСНСИ.ДобавитьЗапись(ЭлементСтруктуры.ПредметСнабжения, Идентификатор, Перечисления.СостоянияОбменаСНСИ.ЗапросНаПрисвоениеКодаСформирован);
		КонецЦикла; // Для Каждого ПредметСнабжения Из ПредметыСнабжения Цикл
		
		ЗафиксироватьТранзакцию();
	Исключение
		Результат = Ложь;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось сформировать запрос: " + ОписаниеОшибки());
		ОтменитьТранзакцию();
	КонецПопытки;
	
	Возврат Результат;
КонецФункции // СформироватьЗапросНаПрисвоениеКода

//////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ РЕГЛАМЕНТНЫХ ЗАДАНИЙ

Процедура ОбменС_НСИ_ПолучениеПочты() Экспорт
	УчетнаяЗапись 	= Справочники.УчетныеЗаписиЭлектроннойПочты.ОбменСНСИ;
	
	// Загрузка почтовых сообщений
	ПараметрыЗагрузки 	= Новый Структура;
	ПараметрыЗагрузки.Вставить("ТолькоНеПрочитанные", Истина);
	Попытка
		Сообщения = РаботаСПочтовымиСообщениями.ЗагрузитьПочтовыеСообщения(УчетнаяЗапись, ПараметрыЗагрузки);
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось получить почту: " + ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	
	Для Каждого Сообщение Из Сообщения Цикл
		СохранитьСообщение(Сообщение, УчетнаяЗапись);
	КонецЦикла; // Для Каждого Сообщение Из Сообщения Цикл
КонецПроцедуры // ОбменсНСИ_ПолучениеПочты

Процедура ОбменС_НСИ_ОбработкаПочты() Экспорт
	УчетнаяЗапись 	= Справочники.УчетныеЗаписиЭлектроннойПочты.ОбменСНСИ;
	
	Запрос 			= Новый Запрос;
	Запрос.Текст 	= "ВЫБРАТЬ
	             	  |	ПочтовыеСообщенияВходящие.ПочтовоеСообщение КАК ПочтовоеСообщение
	             	  |ИЗ
	             	  |	РегистрСведений.ПочтовыеСообщенияВходящие КАК ПочтовыеСообщенияВходящие
	             	  |ГДЕ
	             	  |	ПочтовыеСообщенияВходящие.КоличествоПопыток < 5
	             	  |	И НЕ ПочтовыеСообщенияВходящие.Обработано
	             	  |	И ПочтовыеСообщенияВходящие.ПочтовоеСообщение.Получатель = &УчетнаяЗапись";
	Запрос.УстановитьПараметр("УчетнаяЗапись", УчетнаяЗапись);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбработатьПочтовоеСообщение(Выборка.ПочтовоеСообщение);
	КонецЦикла; // Пока Выборка.Следующий() Цикл
КонецПроцедуры // ОбменС_НСИ_ОбработкаПочты

