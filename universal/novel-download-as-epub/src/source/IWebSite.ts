

interface IWebSite{
    readonly name:string
    readonly domain:string
    init(book:Book):void
    refreshBookInfo(book: Book): void
    refreshCategory(book:Book): void
    refreshContent(chapter:Chapter): void
}



