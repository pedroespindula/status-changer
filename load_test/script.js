import http from 'k6/http';

export const options = {
  stages: [
    { target: 1, duration: '1m' },
  ]
};

const possible_status = [
  { status: 200, weight: 80 },
  { status: 201, weight: 10 },
  { status: 404, weight: 8 },
  { status: 500, weight: 2 },
]

function weight(arr) {
  return [].concat(...arr.map((obj) => Array(Math.ceil(obj.weight * 100)).fill(obj))); 
}

function pick(arr) {
  const weighted = weight(arr);

  const random_index = Math.floor(Math.random() * weighted.length)
  
  return weighted[random_index]
}

function get_random_status_code() {
  return pick(possible_status).status
}

export default function () {
  const payload = JSON.stringify({
    status_code: get_random_status_code(),
  });

  const params = {
    headers: {
      'Content-Type': 'application/json',
    },
  };

  http.post(__ENV.HOST, payload, params);
}
