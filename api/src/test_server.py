import pytest

from .server import app


@pytest.fixture
def client():
    app.config['TESTING'] = True

    with app.test_client() as test_client:
        yield test_client


def test_ping_status_code(client):
    response = client.get('/')

    error_message = 'should be 200'
    assert response.status_code == 200, error_message


def test_post_status_code(client):
    status_code = 404

    response = client.post('/', json={"status_code": status_code})

    error_message = 'should be {}'.format(status_code)
    assert response.status_code == status_code, error_message
