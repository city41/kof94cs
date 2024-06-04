/**
 * buildThankYouMessage.ts
 *
 * This is the message that is displayed when winning the game.
 */
import * as path from "path";
import * as fsp from "fs/promises";

const message = `




          Thanks for playing

          King Of Fighters 1994

          Team Edit Edition!

  
          Doing a real ending

          wasn't really possible.

          So, uh, this is the ending.

  
          See you next time!



  

          created by City41
            thanks to SieKensou`;

function tableToAsm(table: number[]): string[] {
  const columnHeight = 32;

  return table.map((ctv, i) => {
    let comment = "";
    if (i % columnHeight === 0) {
      comment = `; column: ${i / columnHeight}\n`;
    }

    return `${comment}dc.b $${ctv.toString(16)} ; ${String.fromCharCode(ctv)}`;
  });
}

async function writeTablesToAsm(table: number[]): Promise<void> {
  const tableDcs = tableToAsm(table);

  const asm = `;;; thank you message table, generated by buildThankYouMessage.ts
${tableDcs.join("\n")}
`;

  return fsp.writeFile(path.resolve("src/patches/thankYouMessage.asm"), asm);
}

function buildTable() {
  const lines = message.split("\n").map((l) => {
    const fillerLength = 40 - l.length;
    const filler = new Array(fillerLength).fill(" ").join("");

    return `${l}${filler}`;
  });

  while (lines.length < 32) {
    lines.push(new Array(40).fill(" ").join(""));
  }

  const msgTable: number[] = [];

  for (let x = 0; x < 40; ++x) {
    for (let y = 0; y < 32; ++y) {
      const c = lines[y]?.[x] ?? " ";

      msgTable.push(c.charCodeAt(0));
    }
  }

  return msgTable;
}

async function main(): Promise<void> {
  const msgTable = buildTable();
  await writeTablesToAsm(msgTable);
}

const [_tsnode, _buildCutscene2Tables] = process.argv;

main()
  .then(() => console.log("done"))
  .catch((e) => console.error(e));
