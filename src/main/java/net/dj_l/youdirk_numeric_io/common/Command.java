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


package net.dj_l.youdirk_numeric_io.common;
import net.dj_l.youdirk_numeric_io.*;


/**
 * Every <code>Command</code> must implement these abstract methods to
 * construct a syntax and add an event handler during executing the
 * ingame command.
 *
 * <p>Make sure that your <code>Command</code> class implements the
 * following <code>static</code> method:</p>
 *
 * <pre><code>
 *{@literal @}Mod.EventBusSubscriber(bus=Mod.EventBusSubscriber.Bus.MOD)
 * public class MyCommand extends Command<MyNetMessage>
 * {
 *  {@literal @}SubscribeEvent
 *   public static void
 *   onRegister(final RegistryEvent.Register<Command> event)
 *   {
 *     event.getRegistry().register(new MyCommand());
 *   }
 *
 *   . . .
 *
 * }
 * </code></pre>
 */
public abstract class Command<T extends Command<T>>
  extends CommandBase implements Runnable
{
  /**
   * A default constructor without any parameter must be implemented
   * to instanciate dummy objects.  It can be empty, but
   * <code>super(String registryPath)</code> must be called.
   */
  protected Command(String registryPath)
  {
    super(registryPath);
  }

  /**
   * TODO: Encode <code>this</code> to <code>buf</code>
   */
  protected abstract void encode();

  /* *****************************************************************
   * Final stuff
   */

  @Override
  public final void run()
  {
  }
}
