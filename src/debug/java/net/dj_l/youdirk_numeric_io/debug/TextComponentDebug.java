/* This file is part of the `youdirk_numeric_io` Minecraft mod
 * Copyright (C) 2019  Dirk "YouDirk" Lehmann
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */


package net.dj_l.youdirk_numeric_io.debug;
import net.dj_l.youdirk_numeric_io.common.*;
import net.dj_l.youdirk_numeric_io.*;

// Gameplay
import net.minecraft.util.text.TextComponentTranslation;
import net.minecraft.util.text.Style;
import net.minecraft.util.text.TextFormatting;


/**
 * Style/Format of (translateable) debug messages via
 * <code>ICommandSource</code> interface.
 *
 * <p><b>This class will only be compiled into DebugMode builds.</b></p>
 */
public class TextComponentDebug extends TextComponentTranslation
{
  public TextComponentDebug(String translationKey, Object... args)
  {
    super("debug: " + translationKey, args);

    this._setStyle();
  }

  private void _setStyle()
  {
    Style style = new Style();

    style.setColor(TextFormatting.GREEN);
    style.setItalic(true);

    this.setStyle(style);
  }
}
