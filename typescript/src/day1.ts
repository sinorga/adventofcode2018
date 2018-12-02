import readFile from './fs_util';

const PATH = '../day1.input';

function final_frequency(inputs:Array<string>) {
    return inputs.reduce((acc, input) => Number.parseInt(input) + acc, 0);
}

async function load_input(path: string) {
    let data = await readFile(path);
    return data.split('\n');
}

const run = async () => {
    let inputs = await load_input(PATH);
    let result = final_frequency(inputs);
    console.log('[final_frequency] expected: 439, actual:', result, ', pass:', result == 439);
};

try {
    run();
} catch (error) {
    console.error(error);
}