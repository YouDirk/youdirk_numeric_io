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


package net.dj_l.youdirk_numeric_io.client;
import net.dj_l.youdirk_numeric_io.common.*;
import net.dj_l.youdirk_numeric_io.*;

// Event Bus
import net.minecraftforge.eventbus.api.Event;

// Gameplay
import net.minecraft.world.IWorld;


/**
 * TODO: Just a TestSound event.  Remove this class it if tests are
 * finished!
 *
 * <p>Fired on <code>MOD</code> bus if client got a
 * <code>TestSoundNetMessage</code> over network.</p>
 */
public class TestSoundEvent extends YoudirkNumericIOEvent
{
  private final TestSoundNetMessage testSoundMsg;

  public TestSoundEvent(IWorld world, TestSoundNetMessage testSoundMsg)
  {
    super(world);

    this.testSoundMsg = testSoundMsg;
  }

  public TestSoundNetMessage getTestSoundMsg()
  {
    return testSoundMsg;
  }
}
