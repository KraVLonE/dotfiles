import json
import sys
from pathlib import Path

def netscape_to_json(txt_path: Path, output_folder: Path):
    cookies = []

    with open(txt_path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()

            if not line or line.startswith("#"):
                continue

            parts = line.split("\t")
            if len(parts) < 7:
                continue

            domain, include_subdomains, path, secure, expiry, name, *value_parts = parts

            # ---- FIX expiry ----
            if expiry.isdigit():
                expiry_val = int(expiry)
                expiration = expiry_val if expiry_val > 0 else None
            else:
                expiration = None  # session cookie

            cookies.append({
                "domain": domain,
                "path": path,
                "secure": secure.upper() == "TRUE",
                "expirationDate": expiration,  # ✅ None instead of 0
                "name": name,
                "value": "\t".join(value_parts)
            })

    out_file = output_folder / (txt_path.stem + ".json")

    with open(out_file, "w", encoding="utf-8") as f:
        json.dump(cookies, f, indent=2)

    print(f"✓ {txt_path.name} → {out_file.name} ({len(cookies)} cookies)")
    
def batch_convert(input_folder: str, output_folder: str = "json_output"):
    input_path = Path(input_folder)
    output_path = Path(output_folder)
    output_path.mkdir(exist_ok=True)

    txt_files = list(input_path.glob("*.txt"))
    if not txt_files:
        print("No .txt files found.")
        return

    for txt_file in txt_files:
        netscape_to_json(txt_file, output_path)

    print(f"\nDone. {len(txt_files)} files converted → {output_path}/")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python converter.py <input_folder> [output_folder]")
        print("       output_folder defaults to ./json_output")
    else:
        inp = sys.argv[1]
        out = sys.argv[2] if len(sys.argv) > 2 else "json_output"
        batch_convert(inp, out)
