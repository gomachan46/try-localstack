import unittest
from sample import lambda_handler

class TestLambda(unittest.TestCase):
    def test_lambda(self):
        self.assertEqual(1, 1)

if __name__ == "__main__":
    unittest.main()
