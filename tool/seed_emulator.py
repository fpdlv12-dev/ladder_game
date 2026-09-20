"""스크린샷용 테스트 데이터를 에뮬레이터(루트)의 SharedPreferences 에 직접 주입한다.
adb 로는 한글 입력이 안 되므로 이 방식을 쓴다. 앱을 한 번 실행(온보딩 통과)한 뒤 실행할 것.

실행: python tool/seed_emulator.py [serial]   (기본 emulator-5554)
"""
import json
import os
import subprocess
import sys
import tempfile
from xml.sax.saxutils import escape

ADB = r"C:\Android\Sdk\platform-tools\adb.exe"
SERIAL = sys.argv[1] if len(sys.argv) > 1 else "emulator-5554"
PKG = "com.jun5731.ladder_game"
APP_DIR = f"/data/data/{PKG}"
PREFS = f"{APP_DIR}/shared_prefs/FlutterSharedPreferences.xml"
# shared_preferences_android: 문자열 리스트 = 이 접두어 + JSON
LIST_PREFIX = "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIGxpc3Qu!"

NAMES = ["민수", "지영", "현우", "수빈", "태호", "예린"]
RESULTS = ["커피 사기", "설거지", "통과", "노래 한 곡", "통과", "청소"]


def adb(*args, check=True):
    r = subprocess.run([ADB, "-s", SERIAL, *args], capture_output=True)
    if check and r.returncode != 0:
        raise SystemExit(f"adb {' '.join(args)} failed: {r.stderr.decode(errors='replace')}")
    return r.stdout.decode("utf-8", errors="replace")


def xml_list(key, values):
    return f'    <string name="flutter.{key}">{escape(LIST_PREFIX + json.dumps(values, ensure_ascii=False))}</string>\n'


xml = (
    "<?xml version='1.0' encoding='utf-8' standalone='yes' ?>\n<map>\n"
    '    <boolean name="flutter.onboarded" value="true" />\n'
    f'    <int name="flutter.player_count" value="{len(NAMES)}" />\n'
    '    <int name="flutter.result_preset" value="3" />\n'  # custom
    + xml_list("player_names", NAMES)
    + xml_list("results", RESULTS)
    + "</map>\n"
)

tmp = os.path.join(tempfile.gettempdir(), "FlutterSharedPreferences.xml")
with open(tmp, "w", encoding="utf-8") as f:
    f.write(xml)

adb("root", check=False)
adb("wait-for-device")
adb("shell", "am", "force-stop", PKG)
adb("shell", "mkdir", "-p", f"{APP_DIR}/shared_prefs")
adb("push", tmp, PREFS)
owner = adb("shell", "stat", "-c", "%U", APP_DIR).strip()
adb("shell", "chown", "-R", f"{owner}:{owner}", f"{APP_DIR}/shared_prefs")
adb("shell", "restorecon", "-R", APP_DIR, check=False)
print(adb("shell", "cat", PREFS))
