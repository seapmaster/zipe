////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с почтовыми сообщениями".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму создания нового письма.
//
// Параметры:
//  ПараметрыОтправки - Структура - параметры для заполнения в форме отправки нового письма (все необязательные):
//    * Отправитель - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - учетная запись, с которой может
//                    быть отправлено почтовое сообщение;
//                  - СписокЗначений - список учетных записей, доступных для выбора в форме:
//                      ** Представление - Строка- наименование учетной записи;
//                      ** Значение - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - учетная запись.
//    
//    * Получатель - список почтовых адресов.
//        - Строка - список адресов в формате:
//            [ПредставлениеПолучателя1] <Адрес1>; [[ПредставлениеПолучателя2] <Адрес2>;...]
//        - СписокЗначений - Список адресов.
//            ** Представление - Строка - представление получателя,
//            ** Значение      - Строка - почтовый адрес.
//         - Массив - массив структур, описывающий получателей:
//            ** Адрес                        - Строка - почтовый адрес получателя сообщения;
//            ** Представление                - Строка - представление адресата;
//            ** ИсточникКонтактнойИнформации - СправочникСсылка - владелец контактной информации.
//    
//    * Тема - Строка - тема письма.
//    
//    * Текст - Строка - тело письма.
//    
//    * Вложения - Массив - файлы, которые необходимо приложить к письму (описания в виде структур):
//        ** Структура - описание вложения:
//             *** Представление - Строка - имя файла вложения;
//             *** АдресВоВременномХранилище - Строка - адрес двоичных данных вложения во временном хранилище.
//             *** Кодировка - Строка - кодировка вложения (используется, если отличается от кодировки письма).
//             *** Идентификатор - Строка - (необязательный) используется для отметки картинок, отображаемых в теле письма.
//
//    * УдалятьФайлыПослеОтправки - Булево - удалять временные файлы после отправки сообщения.
//  
//  ОповещениеОЗакрытииФормы - ОписаниеОповещения - процедура, в которую необходимо передать управление после закрытия
//                           формы отправки письма.
//
Процедура СоздатьНовоеПисьмо(ПараметрыОтправки = Неопределено, ОповещениеОЗакрытииФормы = Неопределено) Экспорт
	
	Если ПараметрыОтправки = Неопределено Тогда
		ПараметрыОтправки = Новый Структура;
	КонецЕсли;
	ПараметрыОтправки.Вставить("ОповещениеОЗакрытииФормы", ОповещениеОЗакрытииФормы);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СоздатьНовоеПисьмоПроверкаУчетнойЗаписиВыполнена", ЭтотОбъект, ПараметрыОтправки);
	ПроверитьНаличиеУчетнойЗаписиДляОтправкиПочты(ОписаниеОповещения);
	
КонецПроцедуры

// Если у пользователя нет настроенной учетной записи для отправки писем, то в зависимости от прав либо показывает
// помощник настройки новой учетной записи, либо выводит сообщение о невозможности отправки.
// Предназначена для сценариев, в которых требуется выполнить настройку учетной записи перед запросом дополнительных
// параметров отправки.
//
// Параметры:
//  ОбработчикРезультата - ОписаниеОповещение - процедура, в которую необходимо передать выполнение кода после проверки.
//                                              В качестве результата возвращается Истина, если есть доступная учетная
//                                              запись для отправки почты. Иначе возвращается Ложь.
Процедура ПроверитьНаличиеУчетнойЗаписиДляОтправкиПочты(ОбработчикРезультата) Экспорт
	Если РаботаСПочтовымиСообщениямиВызовСервера.ЕстьДоступныеУчетныеЗаписиДляОтправки() Тогда
		ВыполнитьОбработкуОповещения(ОбработчикРезультата, Истина);
	Иначе
		Если РаботаСПочтовымиСообщениямиВызовСервера.ДоступноПравоДобавленияУчетныхЗаписей() Тогда
			ОткрытьФорму("Справочник.УчетныеЗаписиЭлектроннойПочты.Форма.ПомощникНастройкиУчетнойЗаписи", 
				Новый Структура("КонтекстныйРежим", Истина), , , , , ОбработчикРезультата);
		Иначе	
			ТекстСообщения = НСтр("ru = 'Для отправки письма требуется настройка учетной записи электронной почты.
				|Обратитесь к администратору.'");
			ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьНаличиеУчетнойЗаписиДляОтправкиПочтыЗавершение", ЭтотОбъект, ОбработчикРезультата);
			ПоказатьПредупреждение(ОписаниеОповещения, ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Отправляет табличные документы по электронной почте.
//
// Параметры:
//   ТабличныеДокументы - СписокЗначений - Табличные документы для отправки.
//       * Значение - ТабличныйДокумент - Отправляемый документ.
//       * Представление - Строка - Наименование документа.
//           Используется при сохранении в файл и для вложений.
//   Заголовок - Строка - Необязательный. Заголовок диалога сохранения табличных документов в файл.
//   ПараметрыОтправки - Структура - Необязательный. Параметры письма.
//       * Тема  - Строка - Тема письма.
//       * Текст - Строка - Текст письма.
//
// Порядок работы:
//   1. Проверяется наличие учетной записи, настроенной для отправки.
//      Если учетной записи нет, то открывается помощник настройки.
//   2. Открывается диалог сохранения табличных документов в файлы.
//      Табличные документы сохраняются в файлы.
//   3. Открывается диалог отправки письма.
//
Процедура ОтправитьТабличныеДокументы(ТабличныеДокументы, ЗаголовокСохранения = Неопределено, ПараметрыОтправки = Неопределено) Экспорт
	Контекст = Новый Структура;
	Контекст.Вставить("ТабличныеДокументы", ТабличныеДокументы);
	Контекст.Вставить("Заголовок",          ЗаголовокСохранения);
	Контекст.Вставить("ПараметрыОтправки",  ПараметрыОтправки);
	Обработчик = Новый ОписаниеОповещения("ОтправитьТабличныеДокументыПроверкаУчетнойЗаписиВыполнена", ЭтотОбъект, Контекст);
	ПроверитьНаличиеУчетнойЗаписиДляОтправкиПочты(Обработчик);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Продолжение процедуры СоздатьНовоеПисьмо.
Процедура СоздатьНовоеПисьмоПроверкаУчетнойЗаписиВыполнена(УчетнаяЗаписьНастроена, ПараметрыОтправки) Экспорт
	Перем Отправитель, Получатель, Вложения, Тема, Текст, УдалятьФайлыПослеОтправки;
	
	Если УчетнаяЗаписьНастроена <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	ОповещениеОЗакрытииФормы = ПараметрыОтправки.ОповещениеОЗакрытииФормы;
	
	СтандартнаяОбработка = Истина;
	РаботаСПочтовымиСообщениямиКлиентПереопределяемый.ПередОткрытиемФормыОтправкиПисьма(ПараметрыОтправки, ОповещениеОЗакрытииФормы, СтандартнаяОбработка);
	
	Если Не СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОтправки.Свойство("Отправитель", Отправитель);
	ПараметрыОтправки.Свойство("Получатель", Получатель);
	ПараметрыОтправки.Свойство("Тема", Тема);
	ПараметрыОтправки.Свойство("Текст", Текст);
	ПараметрыОтправки.Свойство("Вложения", Вложения);
	ПараметрыОтправки.Свойство("УдалятьФайлыПослеОтправки", УдалятьФайлыПослеОтправки);
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Взаимодействия") 
		И СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().СозданиеИсходящихПисемДоступно Тогда
			МодульВзаимодействияКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ВзаимодействияКлиент");
			МодульВзаимодействияКлиент.ОткрытьФормуОтправкиПочтовогоСообщения(Отправитель,
				Получатель, Тема, Текст, Вложения, , ОповещениеОЗакрытииФормы);
	Иначе
		ОткрытьПростуюФормуОтправкиПочтовогоСообщения(Отправитель, Получатель,
			Тема,Текст, Вложения, УдалятьФайлыПослеОтправки, ОповещениеОЗакрытииФормы);
	КонецЕсли;
	
КонецПроцедуры

// Интерфейсная клиентская функция, поддерживающая упрощенный вызов простой
// формы редактирования нового письма. При отправке письма через простую
// форму сообщения не сохраняются в информационной базе.
//
// Параметры см. в описании функции СоздатьНовоеПисьмо.
//
Процедура ОткрытьПростуюФормуОтправкиПочтовогоСообщения(Отправитель,
			Получатель, Тема,Текст, СписокФайлов, УдалятьФайлыПослеОтправки, ОписаниеОповещенияОЗакрытии)
	
	ПараметрыПисьма = Новый Структура;
	
	ПараметрыПисьма.Вставить("УчетнаяЗапись", Отправитель);
	ПараметрыПисьма.Вставить("Кому", Получатель);
	ПараметрыПисьма.Вставить("Тема", Тема);
	ПараметрыПисьма.Вставить("Тело", Текст);
	ПараметрыПисьма.Вставить("Вложения", СписокФайлов);
	ПараметрыПисьма.Вставить("УдалятьФайлыПослеОтправки", УдалятьФайлыПослеОтправки);
	
	ОткрытьФорму("ОбщаяФорма.ОтправкаСообщения", ПараметрыПисьма, , , , , ОписаниеОповещенияОЗакрытии);
КонецПроцедуры

// Выполняет проверку учетной записи.
//
// Параметры:
// УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - учетная запись,
//					которую нужно проверить.
//
Процедура ПроверитьУчетнуюЗапись(Знач УчетнаяЗапись) Экспорт
	ОчиститьСообщения();
	Состояние(НСтр("ru = 'Проверка учетной записи'"),,НСтр("ru = 'Выполняется проверка учетной записи. Подождите...'"));
	ПроверитьВозможностьОтправкиИПолученияЭлектроннойПочты(Неопределено, УчетнаяЗапись);
КонецПроцедуры

// Проверка учетной записи электронной почты.
//
// См. описание процедуры РаботаСПочтовымиСообщениямиСлужебный.ПроверитьВозможностьОтправкиИПолученияЭлектроннойПочты.
//
Процедура ПроверитьВозможностьОтправкиИПолученияЭлектроннойПочты(ОбработчикРезультата, УчетнаяЗапись)
	
	СообщениеОбОшибке = "";
	ДополнительноеСообщение = "";
	РаботаСПочтовымиСообщениямиВызовСервера.ПроверитьВозможностьОтправкиИПолученияЭлектроннойПочты(УчетнаяЗапись, СообщениеОбОшибке, ДополнительноеСообщение);
	
	Если ЗначениеЗаполнено(СообщениеОбОшибке) Тогда
		ПоказатьПредупреждение(ОбработчикРезультата, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Проверка параметров учетной записи завершилась с ошибками:
					   |%1'"), СообщениеОбОшибке ),,
			НСтр("ru = 'Проверка учетной записи'"));
	Иначе
		ПоказатьПредупреждение(ОбработчикРезультата, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Проверка параметров учетной записи завершилась успешно. %1'"),
			ДополнительноеСообщение),,
			НСтр("ru = 'Проверка учетной записи'"));
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьНаличиеУчетнойЗаписиДляОтправкиПочтыЗавершение(ОбработчикРезультата) Экспорт
	ВыполнитьОбработкуОповещения(ОбработчикРезультата, Ложь);
КонецПроцедуры

// Продолжение процедуры ОтправитьТабличныеДокументы.
Процедура ОтправитьТабличныеДокументыПроверкаУчетнойЗаписиВыполнена(УчетнаяЗаписьНастроена, Контекст) Экспорт
	Если УчетнаяЗаписьНастроена <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ТабличныеДокументы, Заголовок");
	ЗаполнитьЗначенияСвойств(ПараметрыФормы, Контекст);
	
	Обработчик = Новый ОписаниеОповещения("ОтправитьТабличныеДокументыСохранениеВыполнено", ЭтотОбъект, Контекст);
	
	ОткрытьФорму("ОбщаяФорма.ОтправкаТабличныхДокументовПоПочте", ПараметрыФормы, , , , , Обработчик);
КонецПроцедуры

// Продолжение процедуры ОтправитьТабличныеДокументыПроверкаУчетнойЗаписиВыполнена.
Процедура ОтправитьТабличныеДокументыСохранениеВыполнено(СохраненныеДокументы, Контекст) Экспорт
	Если СохраненныеДокументы = Неопределено Или СохраненныеДокументы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОтправки = Контекст.ПараметрыОтправки;
	Если ТипЗнч(ПараметрыОтправки) <> Тип("Структура") Тогда
		ПараметрыОтправки = Новый Структура;
	КонецЕсли;
	
	Вложения = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыОтправки, "Вложения");
	Если ТипЗнч(Вложения) = Тип("СписокЗначений") И Вложения.Количество() > 0 Тогда
		Для Каждого ДокументВложение Из СохраненныеДокументы Цикл
			//АВ+
			ЗаполнитьЗначенияСвойств(Вложения.Добавить(), ДокументВложение);
		КонецЦикла;
	Иначе
		ПараметрыОтправки.Вставить("Вложения", СохраненныеДокументы);
	КонецЕсли;
	
	УдалятьФайлыПослеОтправки = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыОтправки, "УдалятьФайлыПослеОтправки");
	Если ТипЗнч(УдалятьФайлыПослеОтправки) <> Тип("Булево") Тогда
		ПараметрыОтправки.Вставить("УдалятьФайлыПослеОтправки", Истина);
	КонецЕсли;
	
	СоздатьНовоеПисьмо(ПараметрыОтправки);
КонецПроцедуры

#КонецОбласти
