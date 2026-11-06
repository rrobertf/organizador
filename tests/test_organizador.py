from pathlib import Path
import os
import subprocess
import tempfile
import unittest

SCRIPT = Path(__file__).resolve().parents[1] / 'organizador.sh'

class OrganizerTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.folder = self.root / 'Downloads'
        self.folder.mkdir()

    def run_script(self, *args):
        return subprocess.run(['bash', str(SCRIPT), *args], text=True, capture_output=True,
                              env={**os.environ, 'HOME': str(self.root)})

    def test_collision_preserves_both_files(self):
        (self.folder / 'Imagenes').mkdir()
        (self.folder / 'Imagenes' / 'photo.jpg').write_text('old')
        (self.folder / 'photo.jpg').write_text('new')
        result = self.run_script()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual((self.folder / 'Imagenes' / 'photo.jpg').read_text(), 'old')
        self.assertEqual((self.folder / 'photo.jpg').read_text(), 'new')

    def test_dry_run_changes_nothing(self):
        (self.folder / 'a.pdf').write_text('data')
        result = self.run_script('--dry-run', str(self.folder))
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual([p.name for p in self.folder.iterdir()], ['a.pdf'])

    def test_extension_case_spaces_unknown_and_symlink(self):
        (self.folder / 'A file.PDF').write_text('document')
        (self.folder / 'archive.zip').write_text('archive')
        (self.folder / 'link.pdf').symlink_to(self.folder / 'A file.PDF')
        result = self.run_script(str(self.folder))
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual((self.folder / 'Documentos' / 'A file.PDF').read_text(), 'document')
        self.assertEqual((self.folder / 'Otros' / 'archive.zip').read_text(), 'archive')
        self.assertTrue((self.folder / 'link.pdf').is_symlink())

    def test_rejects_symlink_destination(self):
        outside = self.root / 'outside'
        outside.mkdir()
        (self.folder / 'Imagenes').symlink_to(outside, target_is_directory=True)
        (self.folder / 'photo.jpg').write_text('keep')
        result = self.run_script(str(self.folder))
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(list(outside.iterdir()), [])
        self.assertTrue((self.folder / 'photo.jpg').exists())

    def test_missing_folder_does_not_create_it(self):
        missing = self.root / 'missing'
        result = self.run_script(str(missing))
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(missing.exists())

if __name__ == '__main__':
    unittest.main()
