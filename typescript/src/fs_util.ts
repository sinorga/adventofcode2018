import * as fs from  'fs';

export default function readFile(path: string, opts = 'utf8'): Promise<string> {
    return new Promise<string>((resolve, reject) => {
        fs.readFile(path, opts, (err, data: string) => {
            err ? reject(err) : resolve(data);
        });
    });
};