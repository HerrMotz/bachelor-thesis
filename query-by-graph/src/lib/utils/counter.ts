class IdCounter {
    private static instance: IdCounter;
    private count: number = 0;

    private constructor() {}

    public static getInstance(): IdCounter {
        if (!IdCounter.instance) {
            IdCounter.instance = new IdCounter();
        }
        return IdCounter.instance;
    }

    public getNext(): number {
        this.count++;
        return this.count;
    }

    public getCurrent(): number {
        return this.count;
    }
    
    public next(): void {
        this.count++;
    }
}

export const counter = IdCounter.getInstance();