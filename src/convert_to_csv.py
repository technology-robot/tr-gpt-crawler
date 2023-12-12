import csv
import json
import argparse

from tqdm import tqdm


if __name__ == "__main__":
    # Set up argument parsing
    parser = argparse.ArgumentParser(description='Convert JSON to CSV.')
    parser.add_argument('input_json_file_path', help='Path to the input JSON file')
    parser.add_argument('csv_file_path', help='Path to the output CSV file')

    # Parse arguments
    args = parser.parse_args()

    with open(args.input_json_file_path, 'r', encoding="utf-8") as f_p:
        json_data = json.load(f_p)

    # Open a file for writing
    with open(args.csv_file_path, mode='w', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)

        # Write the headers
        writer.writerow(json_data[0].keys())

        # Write the JSON data
        for item in tqdm(json_data):
            writer.writerow(item.values())
