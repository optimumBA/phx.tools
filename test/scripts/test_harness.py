"""Exercise Expect with harmless fake installers, never the real system installer."""
import pathlib
import subprocess
import tempfile

harness = pathlib.Path(__file__).with_name('script.exp').resolve()
scenarios = [
    ('exit 7', 7),
    ('printf "Do you want to continue? (y/n) "; read answer; [ "$answer" = y ] || exit 2; printf "Do you want to proceed with the installation? [y/n]"; read answer; [ "$answer" = y ]', 0),
    ('sleep 3', 124),
]
with tempfile.TemporaryDirectory() as directory:
    for index, (body, expected) in enumerate(scenarios):
        script = pathlib.Path(directory) / f'fake-{index}.sh'
        script.write_text('#!/bin/sh\n' + body + '\n')
        script.chmod(0o700)
        result = subprocess.run(['expect', str(harness), str(script), '1'], capture_output=True, timeout=5)
        assert result.returncode == expected, (index, result.returncode, result.stdout, result.stderr)
print('Installer harness prompt, failure and timeout checks passed')
