# Changes since latest release

-   Clarify problems with Bash on Windows in README

    Special thanks to [DetachHead](https://github.com/DetachHead) for pointing out these problems and his suggestions to
    the README!

-   Automatically create .gitignore in .uv

    By creating a `.gitignore` in the `.uv` directory with `*` as its
    content, the whole directory gets automatically ignored by Git.

    Special thanks to [DetachHead](https://github.com/DetachHead) for suggesting this improvement!

-   Add Batch script wrapper for Windows

    The Batch wrapper searches for the git-bash executable and executes the
    actual uv-wrapper with it. This should help Windows developers who are
    mainly using PowerShell or CMD, instead of git-bash and cannot execute
    the Bash script directly.

    The Batch wrapper forwards all arguments to the Bash script, so the both
    can be used interchangeably, for example: `.\uv.bat -V`

    Special thanks to [DetachHead](https://github.com/DetachHead) for suggesting this improvement!

# Changes in 0.1.0

Initial release

This first release works for Linux as well as Windows.
