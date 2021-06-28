////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с почтовыми сообщениями".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается перед открытием формы нового письма.
// Открытие формы может быть отменено изменением параметра СтандартнаяОбработка.
//
// Параметры:
//  ПараметрыОтправки    - Структура - см. описание в РаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо;
//  ОбработчикЗавершения - ОписаниеОповещения - описание процедуры, которая будет вызвана после завершения
//                                              отправки письма.
//  СтандартнаяОбработка - Булево - признак продолжения открытия формы нового письма после выхода из этой
//                                  процедуры. Если установить Ложь, форма письма открыта не будет.
Процедура ПередОткрытиемФормыОтправкиПисьма(ПараметрыОтправки, ОбработчикЗавершения, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

#КонецОбласти