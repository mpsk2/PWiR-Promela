#!/usr/bin/env python3

import os
import stat

SRC_DIR = 'src'
TRAIL_DIR = 'trail'
BIN_DIR = 'bin'


class Mode:
    FILENAME = '{}/{}'.format(SRC_DIR, 'mutual-exclusion.pml')
    TRAIL_FILE = 'mutual-exclusion.pml.trail'

    def __init__(self, flag_name, is_acceptance, rule):
        self.flag_name = flag_name
        self.is_acceptance = is_acceptance
        self.rule = rule

    def spin_head(self):
        return 'spin -a {} -D{}'.format(self.FILENAME, self.flag_name)

    def file_content(self):
        items = [

            '#!/usr/bin/env sh',
            self.spin_head(),
            self.compile(),
            self.pan(),
            self.cp_trail(),
            self.clean(),
        ]

        return '\n'.join(items)

    @staticmethod
    def clean():
        return 'rm pan* *.tmp'

    @property
    def file_prefix(self):
        return '{}-{}'.format(self.flag_name.lower(),self.rule).replace('_', '-')

    def cp_trail(self):
        return 'if [ -f {0} ]; then\necho "move trail file"\n    mv {0} {1}/{2}.trail\nelse\n   echo "Nothing to mv"\nfi'.format(
            self.TRAIL_FILE,
            TRAIL_DIR,
            self.file_prefix
        ).replace('_', '-')

    def compile(self):
        if self.is_acceptance:
            return 'gcc -O2 -o pan pan.c'
        else:
            return 'gcc -O2 -DSAFETY -DREACH -DBFS -o pan pan.c'

    def pan(self):
        minus_m = '-m100000000'
        if self.is_acceptance:
            return './pan -a -N {} {}'.format(self.rule, minus_m)
        else:
            return './pan -I {} -N {}'.format(minus_m, self.rule)

    def save_file(self):
        path = '{}/{}.sh'.format(BIN_DIR, self.file_prefix)
        with open(path, 'w') as f:
            f.write(self.file_content())

        st = os.stat(path)
        os.chmod(path, st.st_mode | stat.S_IEXEC)


class Assertable(Mode):
    def __init__(self):
        raise NotImplementedError()


class LTL(Mode):
    pass


flags = [
    'BASIC',
    'ANDERSON',
    'MCS',
    'MCSWO',
]

all_modes = [
    lambda x: LTL(rule='mutual_exclusion', flag_name=x, is_acceptance=True),
    lambda x: LTL(rule='liveness', flag_name=x, is_acceptance=True),
    lambda x: LTL(rule='bounded_overtaking', flag_name=x, is_acceptance=True),
]

non_basic_modes = [
    # TODO
]

modes = []

for flag in flags:
    for mode in all_modes:
        modes.append(mode(flag))

if __name__ == '__main__':
    for mode in modes:
        mode.save_file()

