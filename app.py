from flask import Flask, jsonify
import utils

app = Flask(__name__)


@app.route('/animals/<animals_id>')
def movie_last(animals_id):
    result = utils.get_data_animal_id(animals_id)
    return jsonify(result)


if __name__ == '__main__':
    app.debug = True
    app.run(host="127.0.0.1", port=5000)
