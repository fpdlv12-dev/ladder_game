"""Google Play 스토어 등록용 이미지 생성.
실행: python tool/make_store_assets.py
입력: assets/icon/icon.png, store/raw/*.png (에뮬레이터 스크린샷 1080x2400)
출력: store/icon-512.png, store/feature-graphic.png, store/screenshots/NN.png (1080x1920)
Windows 폰트(Malgun Gothic) 기준. 다른 OS 면 FONT_* 경로를 바꿀 것.
"""
import os

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = os.path.join(os.path.dirname(__file__), "..")
STORE = os.path.join(ROOT, "store")
RAW = os.path.join(STORE, "raw")
SHOTS = os.path.join(STORE, "screenshots")
os.makedirs(SHOTS, exist_ok=True)

TOP = (38, 166, 154)
BOTTOM = (0, 105, 92)
WHITE = (255, 255, 255)
LIGHT = (224, 242, 238)

FONT_BOLD = r"C:\Windows\Fonts\malgunbd.ttf"
FONT_REG = r"C:\Windows\Fonts\malgun.ttf"


def font(path, size):
    return ImageFont.truetype(path, size)


def gradient(w, h):
    img = Image.new("RGB", (w, h))
    px = img.load()
    for y in range(h):
        for x in range(w):
            k = (y / max(h - 1, 1)) * 0.65 + (x / max(w - 1, 1)) * 0.35
            px[x, y] = tuple(int(TOP[i] + (BOTTOM[i] - TOP[i]) * k) for i in range(3))
    return img


def rounded_mask(size, radius):
    m = Image.new("L", size, 0)
    ImageDraw.Draw(m).rounded_rectangle([0, 0, size[0] - 1, size[1] - 1], radius=radius, fill=255)
    return m


def shadow(base, box_size, pos, radius, blur=40, alpha=110):
    sh = Image.new("RGBA", base.size, (0, 0, 0, 0))
    layer = Image.new("RGBA", box_size, (0, 0, 0, alpha))
    sh.paste(layer, (pos[0], pos[1] + 24), rounded_mask(box_size, radius))
    sh = sh.filter(ImageFilter.GaussianBlur(blur))
    base.alpha_composite(sh)


# ---------------------------------------------------------------- 512 아이콘
icon = Image.open(os.path.join(ROOT, "assets", "icon", "icon.png")).convert("RGB")
icon.resize((512, 512), Image.LANCZOS).save(os.path.join(STORE, "icon-512.png"))

# ---------------------------------------------------------------- 피처 그래픽 1024x500
W, H = 1024, 500
fg = gradient(W, H).convert("RGBA")
isz = 300
ic = icon.resize((isz, isz), Image.LANCZOS).convert("RGBA")
ipos = (90, (H - isz) // 2)
shadow(fg, (isz, isz), ipos, 64)
fg.paste(ic, ipos, rounded_mask((isz, isz), 64))
d = ImageDraw.Draw(fg)
tx = 450
d.text((tx, 130), "사다리타기", font=font(FONT_BOLD, 88), fill=WHITE)
d.text((tx + 4, 250), "당첨 · 꽝 · 순서 · 벌칙, 공평하게", font=font(FONT_REG, 36), fill=LIGHT)
d.text((tx + 4, 310), "2~10명 · 로그인 없음 · 결과 복사", font=font(FONT_REG, 26), fill=(178, 223, 215))
fg.convert("RGB").save(os.path.join(STORE, "feature-graphic.png"))

# ---------------------------------------------------------------- 스크린샷 1080x1920
SW, SH = 1080, 1920
# (파일, 윗줄, 아랫줄, 아래쪽 잘라낼 px — 배너가 있으면 340, 없으면 130)
shots = [
    ("s_home.png", "이름과 결과만 적으면", "바로 사다리 타기", 340),
    ("s_mid.png", "이름을 누르면", "사다리를 타고 내려가요", 340),
    ("s_all.png", "모두 타기 한 번에", "결과가 한눈에", 340),
    ("s_summary.png", "결과 정리 · 복사", "단톡방에 바로 공유", 130),
]
for n, (fname, line1, line2, cut) in enumerate(shots, start=1):
    bg = gradient(SW, SH).convert("RGBA")
    d = ImageDraw.Draw(bg)

    f1 = font(FONT_REG, 56)
    f2 = font(FONT_BOLD, 72)
    for text, f, y in ((line1, f1, 140), (line2, f2, 220)):
        w = d.textlength(text, font=f)
        d.text(((SW - w) / 2, y), text, font=f, fill=WHITE)

    # 폰 스크린샷: 상태바(위 ~130px)와 테스트 배너·제스처 바(아래 ~290px) 잘라내고 둥근 모서리
    src = Image.open(os.path.join(RAW, fname)).convert("RGBA")
    src = src.crop((0, 130, src.width, src.height - cut))
    ph = SH - 440
    pw = int(src.width * ph / src.height)
    src = src.resize((pw, ph), Image.LANCZOS)
    ppos = ((SW - pw) // 2, 380)
    shadow(bg, (pw, ph), ppos, 48)
    border = Image.new("RGBA", (pw + 16, ph + 16), (255, 255, 255, 70))
    bg.paste(border, (ppos[0] - 8, ppos[1] - 8), rounded_mask((pw + 16, ph + 16), 56))
    bg.paste(src, ppos, rounded_mask((pw, ph), 48))

    bg.convert("RGB").save(os.path.join(SHOTS, f"{n:02d}.png"))

print("done:", os.path.abspath(STORE))
