import path from "node:path";
import fsp from "node:fs/promises";

const FIX_STARTING_ADDRESS = 0x7031;
const FIX_LINE_LENGTH = 38;

function toFixAsm(input: string): string {
  const lines = input.split("\n");

  const output: string[] = [];

  for (let y = 0; y < lines.length; ++y) {
    const startingAddress = FIX_STARTING_ADDRESS + y;
    const line = lines[y];
    if (line.trim().length > 39) {
      throw new Error(`line too long (${line.trim().length}): ${line}`);
    }
    for (let x = 0; x < FIX_LINE_LENGTH; ++x) {
      const c = line[x] ?? " ";

      const addr = (startingAddress + x * 0x20).toString(16);
      const data = `00${c.charCodeAt(0).toString(16)}`;

      output.push(`dc.l $${addr}${data} ; '${c}'`);
    }
  }

  output.push(`dc.l 0 ; terminator`);

  return output.join("\n");
}

async function main(inputDirPath: string, outputDirPath: string) {
  const moveSetFiles = await fsp.readdir(inputDirPath);

  for (const moveSetFile of moveSetFiles) {
    console.log("processing", moveSetFile);
    const content = (
      await fsp.readFile(path.resolve(inputDirPath, moveSetFile))
    ).toString();
    const asm = toFixAsm(content);

    const baseFilename = path.basename(moveSetFile, ".txt");
    const outputPath = path.resolve(outputDirPath, `${baseFilename}.asm`);
    await fsp.writeFile(outputPath, asm);
    console.log("wrote", outputPath);
  }
}

const [_tsnode, _writeMoveSetData, inputDirPath, outputDirPath] = process.argv;

if (!inputDirPath || !outputDirPath) {
  console.error(
    "usage: tsnode writeMoveSetData <input-dir-path> <output-dir-path>"
  );
  process.exit(1);
}

main(path.resolve(inputDirPath), path.resolve(outputDirPath))
  .then(() => console.log("done"))
  .catch((e) => console.error(e));
