class Ciweimao implements IWebSite{
   
    name: string;
    domain: string;

    refreshBookInfo(book: Book): void {
        throw new Error("Method not implemented.");
    }
    init(book: Book): void {
        throw new Error("Method not implemented.");
    }
    refreshCategory(book: Book): void {
        throw new Error("Method not implemented.");
    }
    refreshContent(chapter: Chapter): void {
        throw new Error("Method not implemented.");
    }
}