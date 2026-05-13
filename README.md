# uv-wrapper

Lightweight project-local wrapper for [`uv`](https://github.com/astral-sh/uv).

The `./uv` script ensures a matching `uv` binary is available in `./.uv/bin`, downloading it from GitHub releases when
needed, then runs it with `--project` set to the current repository.

## Disclaimer

I wrote this wrapper out of necessity for my personal and my work-related projects. I am using it in multiple projects
together with my colleagues, and it works fine for us. But most likely I will not put too much effort into it anymore,
unless I personally need more features than it has now.

So, if you need more supported platforms or features, please open an issue or even better a PR, and we can take a look
together.

## License and Usage

This project is licensed under the BSD Zero Clause License (0BSD).

You are free to copy, modify, and use any code from this repository for any purpose, including commercial use. You do
not need to include this license text or provide attribution when reusing code snippets. However, I would strongly
recommend at least keeping the version information in the wrapper script so that users know exactly which version of the
wrapper they are using.

In short: Copy, paste, and use it however you like.

## Why

- Keep `uv` managed per project.
- Avoid requiring global `uv` installation.
- Pin the `uv` version in source control via `.uv-version`.
- Handle concurrent first-run installs safely with a lock.

## About the Programming Language

The wrapper is written as a Bash script, so you need Bash to execute it.

On Linux this should not be a problem, since Bash is pre-installed on many distributions. If you face problems with
different Shells like Zsh or Dash, please open an issue, so we can try to rewrite the wrapper into a more POSIX-Shell
compliant format.

On Windows, you can use the Git-Bash to execute the script, which is included in the "Git-for-Windows" installer. Or you
can use a dedicated environment like WSL or MSYS2 to run Bash. Be extra careful when you download the wrapper or copy
and paste the content into a new file. Windows editors or shells like the PowerShell on Windows tend to create files
with `UTF-16` encoding and use `CRLF` line endings. This can render the file unusable by Bash, with errors like:
`bash: ./uv: cannot execute binary file: Exec format error`. Please make sure the wrapper script uses `UTF-8` encoding
and `LF` line endings.

## Quick Start

1.  Copy or download the wrapper to your project:

    ```bash
    cd your/project
    curl -sSL https://raw.githubusercontent.com/FloGa/uv-wrapper/refs/heads/main/uv >uv
    ```

2.  Make sure the wrapper is executable:

    ```bash
    chmod +x ./uv
    ```

3.  Run `uv` commands through the wrapper:

    ```bash
    ./uv --version
    ./uv sync
    ./uv run python -V
    ```

    On first run, the wrapper downloads and verifies the configured `uv` release. If no `.uv-version` file is present,
    the wrapper will download the latest release from GitHub and create a `.uv-version` file with the pinned version.

4.  Check `.uv-version` and `uv` into source control, for example, Git:

    ```bash
    git add .uv-version uv
    git commit -m "Add uv wrapper"
    ```

## Requirements

- OS:
    - Linux
    - Windows (requires a Bash executable like the `Git-Bash`,
      see ["About the Programming Language"](#about-the-programming-language)
- Architecture:
    - `x86_64`
    - `aarch64`
- Tools available in `PATH`:
    - `curl`
    - `sha256sum`
    - plus archive tools:
        - Linux: `tar`, `gunzip`
        - Windows: `unzip`

## Version Management

Version pinning is done via `.uv-version`. To use a different version, simply change the value in `.uv-version`. On the
next call to `./uv`, the wrapper will download the specified version.

If `.uv-version` is empty or missing, the wrapper resolves the latest release from GitHub and writes it back to
`.uv-version`. So, to quickly switch to the latest release, simply remove `.uv-version` and let it re-create by the
wrapper.

## How It Works

1. Detect OS and architecture.
2. Validate required tools are installed.
3. Acquire an install lock at `./.uv/.install.lock`.
4. Download release archive and `.sha256` from GitHub.
5. Verify checksum.
6. Unpack and place the binary in `./.uv/bin`.
7. Execute:

    ```bash
    ./.uv/bin/uv --project "<repo-dir>" <args>
    ```

## Local Cache Layout

- `./.uv/bin/` - installed `uv` binary (`uv` or `uv.exe`)
- `./.uv/temp/` - temporary extraction directory (removed after install)
- `./.uv/.install.lock/` - transient lock directory used during install

## Troubleshooting

- `Unsupported architecture` / `Unsupported operating system`
    - The current wrapper only supports the OS/arch combinations listed above. For other combinations, please open an
      issue or PR.
- Missing required command (`curl`, `sha256sum`, etc.)
    - Install the missing programs and rerun `./uv`.
- Stale lock detected
    - The script automatically removes stale lock files if the recorded PID is no longer running.
- Version mismatch or corrupted install
    - Remove `./.uv` and rerun `./uv`.
    - This might happen under certain circumstances, like when you are working with your repository in different
      "operating systems" in parallel – for example, you use your repository in Windows and via WSL. Since WSL (Linux)
      needs a different binary than Windows, the wrapper will be confused and might not work as expected. My
      recommendation is, stick to one operating system and avoid switching back and forth. If you absolutely need to,
      make sure to remove the `./.uv` directory and maybe even the virtual Python environment in `./.venv` to ensure a
      clean state when `./uv` is run the next time.
- When executing `./uv`, I get an error message like: `bash: ./uv: cannot execute binary file: Exec format error`
    - This is most likely caused by a wrong file encoding and/or line endings. See
      the ["About the Programming Language"](#about-the-programming-language) section for more information.
    - In short: Make sure the `uv` wrapper script uses `UTF-8` encoding and `LF` line endings, so it can be executed in
      Bash.

## FAQ

1.  Why not use `uv` directly?

    Fair point. Installing uv is not too difficult and is well-documented. However, sometimes even this might stop
    people from using a Python project. "Yuck, another piece of software I need to install to make this run. No,
    thanks!"

    This wrapper provides a true "out-of-the-box" experience, without the need to install anything beforehand (well,
    except for some basic tools like `curl` and `sha256sum` that are most probably already installed anyway).

2.  Do I need to check the `.uv` directory into version control?

    No, absolutely not! The wrapper will automatically download and run the `uv` binary if it is not present. The
    wrapper automatically creates a `.gitignore` in the `.uv` directory to make Git ignore this whole directory.

3.  Do I need to check the `.uv-version` file into version control?

    It is not strictly necessary, but I would highly recommend it to have the most reproducible experience. If the file
    is missing, the wrapper will download the latest release from GitHub and write the version number to the file.

4.  So, if I should check in the `.uv-version` file, then why do you have it in your `.gitignore` in this repository?

    Ah, good catch! This repository does not really use uv in the first place, it is just a means to distribute the
    wrapper. Therefore, I have put the `.uv-version` file into `.gitignore`, so I can test the functionality and avoid
    accidentally committing it.
