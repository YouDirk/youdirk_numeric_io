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


package net.dj_l.youdirk_numeric_io.server;
import net.dj_l.youdirk_numeric_io.common.*;
import net.dj_l.youdirk_numeric_io.*;

// Commands
import com.mojang.brigadier.context.CommandContext;
import com.mojang.brigadier.arguments.ArgumentType;
import com.mojang.brigadier.builder.ArgumentBuilder;
import com.mojang.brigadier.builder.LiteralArgumentBuilder;
import com.mojang.brigadier.builder.RequiredArgumentBuilder;
import net.minecraft.command.Commands;
import net.minecraft.command.CommandSource;

// Non Minecraft/Forge
import javax.annotation.Nullable;


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
 * public class MyCommand extends Command&lt;MyCommand&gt;
 * {
 *  {@literal @}SubscribeEvent
 *   public static void
 *   onRegister(final RegistryEvent.Register&lt;Command&gt; event)
 *   {
 *     event.getRegistry().register(new MyCommand());
 *   }
 *
 *   . . .
 *
 * }
 * </code></pre>
 */
public abstract class Command<T extends Command<T>> extends CommandBase
  implements com.mojang.brigadier.Command<CommandSource>
{
  /**
   * A default constructor without any parameter must be implemented
   * to instanciate dummy objects.  It can be empty, but
   * <code>super(String commandName)</code> must be called.
   */
  protected Command(String commandName)
  {
    super(commandName);
  }

  /**
   * Return the required arguments.  If there are no required
   * arguments or all arguments are optional then return
   * <code>null</code> and <code>onExec()</code> is called if there
   * are no arguments.
   *
   * @return <code>null</code> if no arguments are required
   */
  protected abstract @Nullable ArgumentBuilder<CommandSource,?>
  requiredArguments();

  /**
   * If <code>requiredArguments() == null</code> then this method
   * executes the ingame command with no arguments.  Otherwise it is
   * called if the required arguments could be parsed.
   *
   * @return <code>Command.SINGLE_SUCCESS</code> on success
   */
  protected abstract int
  onExec(CommandContext<CommandSource> context);

  /**
   * Return all other cases which should be parsable.  If there are no
   * alternative argmuents and all arguments are required then return
   * <code>null</code> and <code>onOtherExec()</code> is never called.
   *
   * @return <code>null</code> if no arguments are required
   */
  protected abstract @Nullable ArgumentBuilder<CommandSource,?>
  otherArguments();

  /**
   * If <code>otherArguments() == null</code> then this method will be
   * never called.  Otherwise it is called if the other arguments
   * could be parsed.
   *
   * @return <code>Command.SINGLE_SUCCESS</code> on success
   */
  protected abstract int
  onOtherExec(CommandContext<CommandSource> context);

  /* *****************************************************************
   * Final stuff
   */

  /**
   * Call this method to create a <code>new
   * LiteralArgumentBuilder</code> so that all types are matches
   * correctly.
   */
  protected final LiteralArgumentBuilder<CommandSource>
  newLiteral(String name)
  {
    return Commands.literal(name);
  }

  /**
   * Call this method to create a <code>new
   * RequiredArgumentBuilder</code> so that all types are matches
   * correctly.
   */
  protected final <T> RequiredArgumentBuilder<CommandSource,T>
  newArgument(String name, ArgumentType<T> type)
  {
    return Commands.argument(name, type);
  }

  /**
   * This method produces the whole literal command which you can put
   * into <code>CommandDispatcher::register()</code>.
   */
  public final LiteralArgumentBuilder<CommandSource>
  getLiteralForRegister()
  {
    LiteralArgumentBuilder<CommandSource> result
      = this.newLiteral(this.COMMAND_NAME);

    ArgumentBuilder<CommandSource,?> reqArgs = this.requiredArguments();
    if (reqArgs != null) {
      result = result.then(reqArgs.executes(this));
    } else {
      result = result.executes(this);
    }

    ArgumentBuilder<CommandSource,?> otherArgs = this.otherArguments();
    if (otherArgs != null) {
      result = result.then(otherArgs.executes(this::onOtherExec));
    }

    return result;
  }

  @Override
  public final int run(CommandContext<CommandSource> context)
  {
    return this.onExec(context);
  }
}
