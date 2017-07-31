from application.util import metaphone


def test_metaphone():
    assert metaphone('Nick') == 'NK'
