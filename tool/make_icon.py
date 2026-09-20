"""앱 아이콘 생성 스크립트. 실행: python tool/make_icon.py
assets/icon/icon.png (1024x1024, 배경 포함) 과
assets/icon/icon_fg.png (Android adaptive 전경, 투명 배경) 을 만든다.
모티프: 흰 사다리(세로 3줄 + 가로줄) 위에 주황색 경로가 지그재그로 내려가고 끝에 동그란 마커."""
import os

from PIL import Image, ImageDraw, ImageFilter

SIZE = 1024
OUT = os.path.join(os.path.dirname(__file__), "..", "assets", "icon")
os.makedirs(OUT, exist_ok=True)

# 앱 시드 컬러(0xFF00897B) 계열
TOP = (38, 166, 154)
BOTTOM = (0, 105, 92)
LINE = (255, 255, 255)
PATH = (255, 179, 0)
MARK = (255, 112, 67)


def gradient(w, h, a, b, diag=0.3):
    img = Image.new("RGB", (w, h))
    px = img.load()
    for y in range(h):
        for x in range(w):
            k = (y / max(h - 1, 1)) * (1 - diag) + (x / max(w - 1, 1)) * diag
            px[x, y] = tuple(int(a[i] + (b[i] - a[i]) * k) for i in range(3))
    return img


def draw_symbol(layer, scale=1.0):
    """사다리 + 경로. layer 는 RGBA 1024."""
    s = SIZE * scale
    cx, cy = SIZE / 2, SIZE / 2
    w, h = s * 0.50, s * 0.58
    x0, y0 = cx - w / 2, cy - h / 2
    cols = [x0, x0 + w / 2, x0 + w]
    lw = int(s * 0.055)

    # 그림자
    sh = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    sd = ImageDraw.Draw(sh)
    for x in cols:
        sd.line([(x, y0 + s * 0.02), (x, y0 + h + s * 0.02)], fill=(0, 0, 0, 110), width=lw)
    sh = sh.filter(ImageFilter.GaussianBlur(s * 0.02))
    layer.alpha_composite(sh)

    d = ImageDraw.Draw(layer)
    # 세로줄
    for x in cols:
        d.line([(x, y0), (x, y0 + h)], fill=LINE + (255,), width=lw)
        d.ellipse([x - lw / 2, y0 - lw / 2, x + lw / 2, y0 + lw / 2], fill=LINE + (255,))
        d.ellipse([x - lw / 2, y0 + h - lw / 2, x + lw / 2, y0 + h + lw / 2], fill=LINE + (255,))
    # 가로줄: (row 비율, 왼쪽 col 인덱스)
    rungs = [(0.22, 0), (0.42, 1), (0.62, 0), (0.80, 1)]
    for fy, c in rungs:
        y = y0 + h * fy
        d.line([(cols[c], y), (cols[c + 1], y)], fill=LINE + (255,), width=lw)

    # 경로: 가운데 줄에서 출발 → 0.22 에서 왼쪽 → 0.62 에서 오른쪽(가운데) → 0.80 에서 오른쪽 끝
    pw = int(lw * 1.15)
    pts = [
        (cols[1], y0), (cols[1], y0 + h * 0.22), (cols[0], y0 + h * 0.22),
        (cols[0], y0 + h * 0.62), (cols[1], y0 + h * 0.62),
        (cols[1], y0 + h * 0.80), (cols[2], y0 + h * 0.80), (cols[2], y0 + h),
    ]
    d.line(pts, fill=PATH + (255,), width=pw, joint="curve")
    for p in (pts[0], pts[-1]):
        d.ellipse([p[0] - pw / 2, p[1] - pw / 2, p[0] + pw / 2, p[1] + pw / 2], fill=PATH + (255,))
    # 도착 마커
    r = s * 0.075
    ex, ey = pts[-1]
    d.ellipse([ex - r, ey - r, ex + r, ey + r], fill=MARK + (255,), outline=LINE + (255,), width=int(s * 0.014))


# 1) 풀 아이콘 (스토어용, 불투명)
bg = gradient(SIZE, SIZE, TOP, BOTTOM).convert("RGBA")
sym = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
draw_symbol(sym)
bg.alpha_composite(sym)
bg.convert("RGB").save(os.path.join(OUT, "icon.png"))

# 2) Adaptive 전경 (Android, 투명 배경). flutter_launcher_icons 가 인셋을 넣으므로 그대로.
fg = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
draw_symbol(fg, scale=1.0)
fg.save(os.path.join(OUT, "icon_fg.png"))

print("written:", os.path.abspath(OUT))
