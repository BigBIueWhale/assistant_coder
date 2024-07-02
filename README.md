# Local Offline `GitHub Copilot` alternative

## Technology Stack

* Continue.dev Visual Studio Code extension for chat and autocomplete

* Ollama to run the model on GPU / CPU (tested with Nvidia GPU with 24 GB VRAM), and provide a network API to serve the Continue.dev client.

* 4-bit quantized version of Codestral 22B by the Frensh company Mistral AI, 12 GB model.

* Tested on Windows 10 x86_64 Build 1903 operating system

## Client Setup (end users)

1. You have to install VS Code that is either this version `VSCodeUserSetup-x64-1.90.2.exe` or newer on any client computer on the internal network that will use the AI services. You can download from https://update.code.visualstudio.com/1.90.2/win32-x64-user/stable which is a version of VS Code that supports the provided version of the `Continue`.

2. Any client will need the `Continue` VS Code extension for your operating system + CPU architecture. Use the pre-downloaded version `continue-win32-x64-0.8.40.vsix` which you can download from: https://github.com/continuedev/continue/releases/tag/v0.8.40-vscode (scroll all the way down to `Assets`. The .vsix file can then be installed globally as an extension in VS Code as if you installed the extension from the internet (Extensions tab -> ... -> `install from vsix`).

3. Drag the newly added extension tab to the right like it asked you

4. In the welcome page: `Welcome to Continue` choose `Local models` and click `Continue`. Ignore the `Failed to connect` error that then keeps popping up

5. Click `Continue` again

6. Click the `Configure` gear icon ⚙ in the bottom right of the `Continue` extension window. That will open a `config.json` for you to edit.

7. Change it to look like this (replace 127.0.0.1 IP with the actual server's IP)
```json
{
  "models": [
    {
      "title": "Codestral",
      "provider": "ollama",
      "model": "codestral:22b",
      "apiBase": "http://127.0.0.1:11434/",
      "systemMessage": "Do exactly as the user says / means"
    }
  ],
  "tabAutocompleteModel": {
    "title": "Codestral",
    "provider": "ollama",
    "model": "codestral:22b",
    "apiBase": "http://127.0.0.1:11434/"
  },
  "allowAnonymousTelemetry": false
}
```

8. Save the json file, and then reload VS Code window. Now you should be able to chat with `Continue` in its extension window (as long as the server is running on the internal network).

## Client Usage

1. Open VS Code in a specific project, and press F1 key on your keyboard. That should open VS Code's command palette. Start typing: `Continue: ` to see the options of what the AI can do for you while you're programming your code.

2. Select any length of text / code.

3. Run VS Code command (F1 -> type) `Continue: Add Highlighted Code to Context`, then type your prompt to ask the AI.

4. Example chat with the chat interface:

![Create realistic tree](create_realistic_tree.jpg)

![Realistic Looking Tree](p5_js_tree.png)

5. Ingest huge prompts, up to 32,000 tokens (400+ line readme within seconds).

6. Do some code completion by pressing CTRL+i at any moment while writing code. It'll add code where your cursor currently is. It'll ask you for instructions. The simplest instructions you can give it is: `complete here`.

![CTRL+I autocomplete](./ctrl_i_autocomplete.jpg)

7. Multi-turn conversations- Codestral keeps the context alive better than any LLM I know- it managed to win in the game of 20 questions!

![Very good multi-turn conversations 1](./very_good_multi_turn_conversations_1.jpg)

![Very good multi-turn conversations 2](./very_good_multi_turn_conversations_2.jpg)

8. Select files as context

![Select files as context](./select_files_as_context.jpg)

9. Generate working UML syntax. Ask it to generate PlantUML (planttext.com) syntax

## Server Setup
I installed `OllamaSetup.exe` for Windows on an online Windows 11 computer after I downloaded it from https://github.com/ollama/ollama/releases/tag/v0.1.48

I ran the command: `ollama pull codestral:22b` to download https://ollama.com/library/codestral which is 12 GB in size (it's quantized). It downloads into `C:/Users/YOUR_USERNAME/.ollama` folder

I then followed this guide https://ollama/blog/continue-code-assistant which essentially says that the command to run the server is: `ollama run codestral:22b`.

That however will only run on localhost, so instead, just run this batch file [Run Ollama](./run_ollama.bat).

When `Continue` requests to use the model, it'll automatically be loaded.

Of course, you have to install ollama on the offline computer, and copy the pulled model from the `.ollama` folder in the online computer to `C:/Users/YOUR_USERNAME/.ollama` folder in the offline computer (and create it if it doesn't exist).

Before deleting all of the existing files in the .ollama folder on your offline computer, stop Ollama from running:

![Quit Ollama](./quit_ollama.jpg)

You should be able to process long context lengths within 10 seconds (like, an entire readme of a large project). If you can't: shut down ollama from the system tray, close all apps (or restart PC), and launch it again. You need to make sure that you launch it when you have enough VRAM available so that the entire model gets loaded into the GPU.

If some of the model gets into the CPU, that hurts prompt ingestion speed 40x (not sure if this is true, it might sometimes just get stuck for now reason until restarting Ollama).

Disable Ollama from running on startup (in Task Manager startup items), so that we can have our batch file run on user login instead.

![Run on startup](./run_on_startup.jpg)

## Known Issues

* Only 1 prompt at a single time (more an issue of insufficient hardware)

* Sometimes gets loaded automatically into CPU when the GPU memory is too full

* When chatting, the cancel doesn't always cancel (it maybe actually never). That means that if the LLM wants to give you a long response, you'll have to wait a while until you can ask again (or you can kill Ollama and start it again).