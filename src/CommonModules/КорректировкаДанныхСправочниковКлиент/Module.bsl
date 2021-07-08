#Область ОбменДаннымиСПоставщиками

Процедура ЗаполнитьПродолжение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		ЗаполнитьТабличныеЧасти(ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьТабличныеЧасти(Параметры)
	
	Если Параметры.ВариантЗаполнения = 0 Тогда
		
		ЗаполнитьТабличныеЧастиПродолжение(0, Параметры);
		
	Иначе      
		
		Если Параметры.ВариантЗаполнения = 1 Тогда
			
			ФормаВыбора = "Справочник.КаталогПредметовСнабжения.Форма.ФормаСписка";
			
		ИначеЕсли Параметры.ВариантЗаполнения = 2 Тогда
			
			ФормаВыбора = "Документ.Заявка.Форма.ФормаСписка";
			
		ИначеЕсли Параметры.ВариантЗаполнения = 3 Тогда
			
			ФормаВыбора = "Документ.Контракт.Форма.ФормаСписка";
			
		ИначеЕсли Параметры.ВариантЗаполнения = 4 Тогда
			
			ФормаВыбора = "БизнесПроцесс.ЗапросНаАктуализациюКаталогаПоставщика.Форма.ФормаВыбораИзКаталога";
			
		Иначе
			
			Возврат;
			
		КонецЕсли;
			
			ОткрытьФорму(ФормаВыбора, Новый Структура("РежимВыбора, МножественныйВыбор, ПоставщикПараметр", Истина, Истина, Параметры.Поставщик), 
				ЭтотОбъект, , , , Новый ОписаниеОповещения("ЗаполнитьТабличныеЧастиПродолжение", ЭтотОбъект, Параметры));


	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьТабличныеЧастиПродолжение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	
	Форма = ДополнительныеПараметры.Форма;
	//АВ+
	ДополнительныеПараметры.Удалить("Форма");
	
	Если РезультатЗакрытия = 0 Или ТипЗнч(РезультатЗакрытия) = Тип("Массив") Тогда
		
		Если РезультатЗакрытия = 0 Тогда
			
			РезультатЗакрытия = Неопределено;
			
		КонецЕсли;
		
		Параметры = КорректировкаДанныхСправочников.ЗаполнитьПредметыСнабженияИХарактеристики(РезультатЗакрытия, ДополнительныеПараметры);
		
		КопироватьДанныеФормы(Параметры.ПредметыСнабжения, Форма.Объект.ПредметыСнабжения);
		КопироватьДанныеФормы(Параметры.Характеристики, Форма.Объект.Характеристики);
		
		Если ДополнительныеПараметры.Свойство("Аналоги") Тогда
			
			Форма.Объект.Аналоги.Очистить();
			
		КонецЕсли;
		
	КонецЕсли; 
	
КонецПроцедуры

Асинх Функция ВыгрузитьФайлПоставщику(ПредметыСнабжения, Характеристики, ИмяФайла) Экспорт
	
	Если ПредметыСнабжения.Количество() = 0 Тогда
		ПоказатьПредупреждение(, "Нет данных для выгрузки!");
		Возврат Неопределено;
	КонецЕсли; // Если ПредметыСнабжения.Количество() = 0 Тогда
	
	//создание файла
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ДиалогВыбораФайла.ПолноеИмяФайла 		= ИмяФайла;
	ДиалогВыбораФайла.МножественныйВыбор 	= Ложь;
	ДиалогВыбораФайла.Заголовок 			= "Выберите файл для выгрузки:";
	ДиалогВыбораФайла.Фильтр 				= "Excel файлы(*.xls;*.xlsx)|*.xls;*.xlsx";
	
	РезультатВыбора = Ждать ДиалогВыбораФайла.ВыбратьАсинх();
	Если РезультатВыбора = Неопределено Тогда
		Возврат Неопределено;
	Иначе
		ПутьКФайлу = РезультатВыбора[0];
	КонецЕсли;
	
	ДокументыКЗаписи = РаботаСФайламиOffice.ПодготовитьТабличныеДокументыКорректировкаДанныхСправочников(ПредметыСнабжения, Характеристики);
	Если ДокументыКЗаписи = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли; // Если ДокументыКЗаписи = Неопределено Тогда
	
	Если РаботаСФайламиOfficeКлиент.ЗаписатьЛистыВОдинДокумент(ПутьКФайлу, ДокументыКЗаписи) Тогда
		Возврат ПутьКФайлу;
	Иначе
		Возврат Неопределено;
	КонецЕсли; // Если РаботаСФайламиOfficeКлиент.ЗаписатьЛистыВОдинДокумент(ПутьКФайлу, ДокументыКЗаписи) Тогда
		
КонецФункции

Процедура ПослеВыбораФайлаСохранение(Результат, ДополнительныеПараметры) Экспорт
		
КонецПроцедуры // ПослеВыбораФайлаСохранение

Асинх Функция ЗагрузитьФайлОтПоставщика(Форма, ТаблицыВОбъекте) Экспорт
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	ДиалогОткрытияФайла.Фильтр = "Документ MS Excel 2010 (*.xlsx)|*.xlsx|Документ MS Excel(*.xls)|*.xls";
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = "Выберите файл поставщика:";
	
	РезультатВыбрать = ДиалогОткрытияФайла.ВыбратьАсинх();
	Если РезультатВыбрать = Неопределено Тогда
		Возврат Неопределено;
	Иначе
		РезультатЗагрузки = ВыполнитьЗагрузкуФайлаОтПоставщика(Форма, ТаблицыВОбъекте, РезультатВыбрать[0]);
		Возврат РезультатЗагрузки;
	КонецЕсли;
	
КонецФункции

Функция ВыполнитьЗагрузкуФайлаОтПоставщика(Форма, ЭтоОбработка, ПутьКФайлу) Экспорт
	
	Если ЭтоОбработка Тогда
			
		Форма.Объект.ПредметыСнабжения.Очистить();
		Форма.Объект.Характеристики.Очистить();
		Форма.Объект.Аналоги.Очистить();
		
	Иначе
		
		Форма.ПредметыСнабжения.Очистить();
		Форма.Характеристики.Очистить();
		Форма.Аналоги.Очистить();
		
	КонецЕсли;
		
	// чтение данных из файла
	ПараметрыФайла = РаботаСФайламиOfficeКлиент.ПодготовитьФайлКЧтению(ПутьКФайлу, "ТабличныйДокумент");
	Если ПараметрыФайла = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли; // Если ПараметрыФайла = Неопределено Тогда
	
	ЛистыДокумента = РаботаСФайламиOffice.ПрочитатьВсеЛистыФайла(ПараметрыФайла);
	Если ЛистыДокумента = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли; //Если ЛистыДокумента = Неопределено Тогда
	
	Если ЛистыДокумента.Количество() < 3 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					"Неккоретная структура файла, обязательные листы: Предметы снабжения, Характеристики, Аналоги");
		Возврат Неопределено;
	КонецЕсли; // Если ЛистыДокумента.Количество() < 3 Тогда
	
	// предметы снабжения	
	ЛистПредметовСнабжения = ЛистыДокумента.Лист_1;
	
	Если Не (ЛистПредметовСнабжения.Область(1, 1).Текст = "Идентификатор" И ЛистПредметовСнабжения.Область(1, 2).Текст = "Входимость") Тогда
		Сообщить("Некорректный формат файла!");
		Возврат Неопределено;
	КонецЕсли; 
	
	ДатаНачала = ТекущаяДата();
	ВсегоСтрок = ЛистПредметовСнабжения.ВысотаТаблицы;
	
	Для Сч = 3 По ВсегоСтрок Цикл
		
		УправлениеИнтерфейсом.ВывестиТекущееСостояние("Чтение предметов снабжения...", ДатаНачала, Сч - 2, ВсегоСтрок - 2);
		
		ГУИД = Формат(ЛистПредметовСнабжения.Область(Сч, 1).Текст, "ЧГ=0");
		Наименование = Формат(ЛистПредметовСнабжения.Область(Сч, 3).Текст, "ЧГ=0");
		
		Если Не ЗначениеЗаполнено(Наименование) Тогда
			Продолжить;
		КонецЕсли;
			
		ПредметСнабжения = КорректировкаДанныхСправочников.ПолучитьСсылкуПоГУИД(ГУИД, "КаталогПредметовСнабжения");
		
		//АВ+
		СтрокаПредметСнабжения = ?(ЭтоОбработка, Форма.Объект.ПредметыСнабжения.Добавить(), Форма.ПредметыСнабжения.Добавить());
		СтрокаПредметСнабжения.ПредметСнабжения 						= ПредметСнабжения;
		СтрокаПредметСнабжения.Наименование 							= Наименование;
		СтрокаПредметСнабжения.Обозначение 								= Формат(ЛистПредметовСнабжения.Область(Сч, 4).Текст, "ЧГ=0");
		СтрокаПредметСнабжения.ДокументНаПоставку 						= Формат(ЛистПредметовСнабжения.Область(Сч, 5).Текст, "ЧГ=0");
		СтрокаПредметСнабжения.ВозможностьИзготовления 					= (ЛистПредметовСнабжения.Область(Сч, 6).Текст = "Да");
		СтрокаПредметСнабжения.СрокИзготовления 						= ПолучитьЧисло(ЛистПредметовСнабжения.Область(Сч, 7).Текст);
		СтрокаПредметСнабжения.Цена 									= ПолучитьЧисло(ЛистПредметовСнабжения.Область(Сч, 8).Текст);
		СтрокаПредметСнабжения.ДатаЦены 								= ПолучитьДату(ЛистПредметовСнабжения.Область(Сч, 9).Текст);
		СтрокаПредметСнабжения.ПравилаУпаковкиТранспортировкиХранения 	= ЛистПредметовСнабжения.Область(Сч, 10).Текст;
		СтрокаПредметСнабжения.Идентификатор 							= ?(ЗначениеЗаполнено(ГУИД), ГУИД, Новый УникальныйИдентификатор());
		СтрокаПредметСнабжения.Согласовано 								= Истина;
		СтрокаПредметСнабжения.ПорядковыйНомер 							= Сч - 2;
		
		ИмяФайлаКартинки = СокрЛП(ЛистПредметовСнабжения.Область(Сч, 11).Текст);
		Если Не ИмяФайлаКартинки = "" Тогда
			
			ПолныйФайл 	= ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ПутьКФайлу);
			Каталог 	= ПолныйФайл.Путь;
			
			Попытка
				ПолныйПутьКартинки = Каталог + ИмяФайлаКартинки;
				ДвоичныеДанные = Новый ДвоичныеДанные(ПолныйПутьКартинки);
			Исключение
				ДвоичныеДанные = Неопределено;
			КонецПопытки;
			
			Если НЕ ДвоичныеДанные = Неопределено Тогда
				
				УИД = новый УникальныйИдентификатор;
				
				Адрес = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УИД);
				
				Если НЕ Адрес = "" Тогда
					
					Если ЭтоОбработка Тогда
						СтрокаПредметСнабжения.Картинка = ПолучитьИзВременногоХранилища(Адрес);
					Иначе
						СтрокаПредметСнабжения.ХранилищеКартинкиВременное = Адрес;
					КонецЕсли; 
					
					СтрокаПредметСнабжения.ИмяФайлаКартинки = ИмяФайлаКартинки;
					
				КонецЕсли;
				
			КонецЕсли; 
			
		КонецЕсли;
		
	КонецЦикла;
	
	//характеристики
	ЛистХарактеристик = ЛистыДокумента.Лист_2;
	
	ДатаНачала = ТекущаяДата();
	ВсегоСтрок = ЛистХарактеристик.ВысотаТаблицы;
	
	Для Сч = 3 По ВсегоСтрок Цикл
		
		УправлениеИнтерфейсом.ВывестиТекущееСостояние("Чтение характеристик...", ДатаНачала, Сч - 2, ВсегоСтрок - 2);
		
		ГУИД 			= 	ЛистХарактеристик.Область(Сч, 1).Текст;
		Наименование 	= ЛистХарактеристик.Область(Сч, 2).Текст;
		
		Если Не ЗначениеЗаполнено(ГУИД) Или Не ЗначениеЗаполнено(Наименование) Тогда
			Продолжить;
		КонецЕсли;
			
		ПредметСнабжения 	= КорректировкаДанныхСправочников.ПолучитьСсылкуПоГУИД(ГУИД, "КаталогПредметовСнабжения");
		Характеристика 		= КорректировкаДанныхСправочников.ПолучитьХарактеристикуПоНаименованию(Наименование, ПредметСнабжения);
		
		//АВ+
		СтрокаХарактеристика = ?(ЭтоОбработка, Форма.Объект.Характеристики.Добавить(), Форма.Характеристики.Добавить());
		СтрокаХарактеристика.ПредметСнабжения 	= ПредметСнабжения;
		СтрокаХарактеристика.Характеристика 	= Характеристика;
		СтрокаХарактеристика.ЕдиницаИзмерения 	= 
					КорректировкаДанныхСправочников.ПолучитьЕдиницуИзмерения(ЛистХарактеристик.Область(Сч, 4).Текст, ЛистХарактеристик.Область(Сч, 3).Текст);
		СтрокаХарактеристика.Основная 			= (ЛистХарактеристик.Область(Сч, 6).Текст = "Да");
		СтрокаХарактеристика.Значение 			= Формат(ЛистХарактеристик.Область(Сч, 5).Текст, "ЧГ=0");
		СтрокаХарактеристика.Идентификатор 		= ГУИД;
		СтрокаХарактеристика.Наименование 		= Наименование;
		СтрокаХарактеристика.ПорядковыйНомер 	= Сч - 2;
				
		Если Не Наименование = "Код ОКП" Тогда //исключения
			
			Попытка
				СтрокаХарактеристика.Значение = Число(СтрокаХарактеристика.Значение);
			Исключение
				// ???			
			КонецПопытки;
			
		КонецЕсли;
					
	КонецЦикла;
	
	//аналоги
	ЛистАналогов = ЛистыДокумента.Лист_3;
	
	ДатаНачала = ТекущаяДата();
	ВсегоСтрок = ЛистАналогов.ВысотаТаблицы;
	
	Для Сч = 3 По ВсегоСтрок Цикл
		
		УправлениеИнтерфейсом.ВывестиТекущееСостояние("Чтение аналогов...", ДатаНачала, Сч - 2, ВсегоСтрок - 2);
		
		ГУИД = ЛистАналогов.Область(Сч, 1).Текст;
		ГУИДАналога = ЛистАналогов.Область(Сч, 2).Текст;
		
		Если Не ЗначениеЗаполнено(ГУИД) Или Не ЗначениеЗаполнено(ГУИДАналога) Тогда
			
			Продолжить;
			
		КонецЕсли;
			
		ПредметСнабжения 	= КорректировкаДанныхСправочников.ПолучитьСсылкуПоГУИД(ГУИД, "КаталогПредметовСнабжения");
		Аналог 				= КорректировкаДанныхСправочников.ПолучитьСсылкуПоГУИД(ГУИДАналога, "КаталогПредметовСнабжения");
		
		//АВ+
		СтрокаАналог = ?(ЭтоОбработка, Форма.Объект.Аналоги.Добавить(), Форма.Аналоги.Добавить());
		СтрокаАналог.ПредметСнабжения 		= ПредметСнабжения;
		СтрокаАналог.Аналог 				= Аналог;
		СтрокаАналог.Идентификатор 			= ГУИД;
		СтрокаАналог.ИдентификаторАналога 	= ГУИДАналога;
					
	КонецЦикла;
	
	Возврат ПутьКФайлу;
	
КонецФункции

Функция ПолучитьЧисло(Значение)
	
	Попытка
		
		Результат = Число(Значение);
		
	Исключение
		
		Результат = 0;
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьДату(Значение)
	
	Попытка
		
		Результат = Дата(Сред(Значение, 7, 4) + Сред(Значение, 4, 2) + Лев(Значение, 2));
		
	Исключение
		
		Результат = Дата("00010101");
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти