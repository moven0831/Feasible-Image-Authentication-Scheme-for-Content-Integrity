import fs from 'fs'
import path from 'path'
import child_process from 'child_process'
import { fileURLToPath } from 'url'
import os from 'os'

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const outDir = path.join(__dirname, '../dist/zkSnarkBuild');
const buildDir = path.join(__dirname, '../circuits');
await fs.promises.mkdir(outDir, { recursive: true });

// remove old files in outDir
const oldFiles = await fs.promises.readdir(outDir);
if (oldFiles.length > 0) {
    console.log(`Cleaning existed files...`);
}
for (const file of oldFiles) {
    const filePath = path.join(outDir, file);
    const fileStats = await fs.promises.stat(filePath);
    await fs.promises.rm(filePath, { recursive: true });
}

// run circom on files in circuit directory
const files = await fs.promises.readdir(buildDir);
for (const file of files) {
    if (path.extname(file) === '.circom') {
        const fileName = path.basename(file, '.circom');
        const filePath = path.join(buildDir, file);
        const command = `circom ${filePath} --r1cs --wasm --c --output ${outDir} --prime vesta`;
        console.log(`Compiling ${file}...`);
        await new Promise((rs, rj) => {
            child_process.exec(command, (err, stdout, stderr) => {
                if (err) rj(err);
                else rs();
            });
        });
        // execute make in the generated directory
        const generatedDir = path.join(outDir, `${fileName}_cpp`);
        console.log(`Compiling ${fileName} C++ witness generator...`);
        await new Promise((rs, rj) => {
            child_process.exec(`make`, { cwd: generatedDir }, (err, stdout, stderr) => {
                if (err) rj(err);
                else rs();
            });
        });
    }
}

console.log(`\nCircuits have been compiled to ${outDir}`);
