#!/usr/bin/env python3

import os
import stat

SRC_DIR = 'src'
TRAIL_DIR = 'trail'
BIN_DIR = 'bin'


class Mode:
    FILENAME = '{}/{}'.format(SRC_DIR, 'mutual-exclusion.pml')
    TRAIL_FILE = 'mutual-exclusion.pml.trail'

    def __init__(self, flag_name, is_acceptance, rule, processes_number=2):
        self.flag_name = flag_name
        self.is_acceptance = is_acceptance
        self.rule = rule
        self.processes_number=processes_number

    def spin_head(self):
        return 'spin -D{} -DNUM_PROCESSES={} -a {}'.format(self.flag_name, self.processes_number, self.FILENAME)

    def file_content(self):
        items = [

            '#!/usr/bin/env sh',
            'rm pan* *.tmp *.trail',
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
        return '{}-{}{}'.format(
            self.flag_name.lower(),
            self.rule,
            '' if self.processes_number == 2 else '-{}'.format(self.processes_number)
        ).replace('_', '-')

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

    minus_m = '-m100000000'

    def pan(self):
        if self.is_acceptance:
            return './pan -a -f {} -N {}'.format(self.minus_m, self.rule)
        else:
            return './pan -I {} -N {}'.format(self.minus_m, self.rule)

    @property
    def path(self):
        return '{}/{}.sh'.format(BIN_DIR, self.file_prefix)

    def save_file(self):
        with open(self.path, 'w') as f:
            f.write(self.file_content())

        st = os.stat(self.path)
        os.chmod(self.path, st.st_mode | stat.S_IEXEC)


class InevitableWaiting(Mode):
    def __init__(self, flag_name, processes_number=2):
        if flag_name == 'BASIC':
            raise NotImplementedError('Does not concern basic.')
        super().__init__(flag_name=flag_name, is_acceptance=False, rule='inevitable-waiting', processes_number=processes_number)

    def spin_head(self):
        return 'spin -D{} -DNUM_PROCESSES={} -DINEVITABLE_WAITING -a {}'.format(self.flag_name, self.processes_number, self.FILENAME)

    def pan(self):
        return './pan -I {}'.format(self.minus_m)


class BoundedOvertaking(Mode):
    def __init__(self, flag_name, processes_number=2):
        super().__init__(flag_name=flag_name, is_acceptance=True, rule='bounded_overtaking', processes_number=processes_number)

    def spin_head(self):
        return 'spin -D{} -DNUM_PROCESSES={} -DWAITING -a {}'.format(self.flag_name, self.processes_number, self.FILENAME)


class FCFS(Mode):
    def __init__(self, flag_name, processes_number=2):
        if flag_name == 'BASIC':
            raise NotImplementedError('Does not concern basic.')
        super().__init__(flag_name=flag_name, is_acceptance=True, rule='fcfs', processes_number=processes_number)

    def spin_head(self):
        return 'spin -D{} -DNUM_PROCESSES={} -DFCFS. -a {}'.format(self.flag_name, self.processes_number, self.FILENAME)


flags = [
    'BASIC',
    'ANDERSON',
    'MCS',
    'MCSWO',
]

all_modes = [
    lambda x: Mode(rule='mutual_exclusion', flag_name=x, is_acceptance=True, processes_number=3),
    lambda x: Mode(rule='liveness', flag_name=x, is_acceptance=True, processes_number=3),
    lambda x: BoundedOvertaking(flag_name=x, processes_number=3),
    lambda x: Mode(rule='mutual_exclusion', flag_name=x, is_acceptance=True),
    lambda x: Mode(rule='liveness', flag_name=x, is_acceptance=True),
    lambda x: BoundedOvertaking(flag_name=x),
]

non_basic_modes = [
    lambda x: InevitableWaiting(flag_name=x),
    lambda x: InevitableWaiting(flag_name=x, processes_number=3),
    lambda x: FCFS(flag_name=x),
    lambda x: FCFS(flag_name=x, processes_number=3),
]

modes = []

for flag in flags:
    for mode in all_modes:
        modes.append(mode(flag))
    for mode in non_basic_modes:
        try:
            modes.append(mode(flag))
        except NotImplementedError:
            pass


if __name__ == '__main__':
    files = [
        '#!/usr/bin/env sh'
    ]

    for mode in modes:
        mode.save_file()
        files.append('./{}'.format(mode.path))

    path = BIN_DIR + '/all.sh'
    with open(path, 'w') as f:
        f.write('\n'.join(files))

    st = os.stat(path)
    os.chmod(path, st.st_mode | stat.S_IEXEC)

