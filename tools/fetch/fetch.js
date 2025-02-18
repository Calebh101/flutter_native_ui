const path = require('path');
const fs = require('fs');
const puppeteer = require('puppeteer');
const { spawn } = require('child_process');
const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

(async () => {
  const name = await new Promise((resolve) => {
    rl.question('Enter class name: >> ', (answer) => {
      resolve(answer);
    });
  });
  
  const library = await new Promise((resolve) => {
    rl.question('Enter class library: >> ', (answer) => {
      resolve(answer);
    });
  });

  rl.close();
  var globalConstructor = "";

  const query = `dt#${name}`;
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  const creator = path.dirname(__dirname) + '/creator';

  page.on('console', (msg) => {
    const text = msg.text();
    if (text.startsWith('CONSTRUCTOR')) {
      const constructor = text.replace('CONSTRUCTOR: ', '').trim();
      globalConstructor = constructor;
      console.log("found constructor: " + constructor);

      const path = creator + '/input.txt';
      fs.writeFileSync(path, constructor, 'utf8');
      console.log("file overwritten: input.txt (" + path + ")");
    } else {
      console.log("browser log: " + text);
    }
  });

  const url = `https://api.flutter.dev/flutter/${library}/${name}-class.html`;
  console.log("opening url: " + url + " with query: " + query);
  await page.goto(url);

  await page.evaluate((query) => {
    console.log("finding constructor with query: " + query);
    const element = document.querySelector(query);
    if (!element) {
      console.error("unable to find element from query: " + query);
    } else {
      console.log("CONSTRUCTOR: " + element.textContent.trim());
    }
  }, query);

  const starter = 'dart';
  const args = ['run', '"' + creator + '/creator.dart' + '"', '"' + name + '"', '"' + globalConstructor + '"'];
  const command = starter + ' '  + args.join(' ');

  console.log("handing over stdio to command: " + command);
  const child = spawn(starter, args, { stdio: 'inherit', shell: true });
  exit(browser);
})();

async function exit(browser) {
  await browser.close();
}
