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

// Server
import net.dj_l.youdirk_numeric_io.server.CommandBase;

// Forge Mod Loader
import net.minecraftforge.fml.common.Mod;

// Event Bus
import net.minecraftforge.eventbus.api.SubscribeEvent;

// Events
import net.minecraftforge.event.RegistryEvent;

// Gameplay
import net.minecraft.server.management.PlayerList;

// Commands
import com.mojang.brigadier.context.CommandContext;
import com.mojang.brigadier.builder.ArgumentBuilder;
import com.mojang.brigadier.arguments.IntegerArgumentType;
import com.mojang.brigadier.Command;
import net.minecraft.command.Commands;
import net.minecraft.command.CommandSource;

// Non Minecraft/Forge
import javax.annotation.Nullable;


/**
 * This ingame command freezes the server thread or dedicated server
 * for the given time of seconds to simulate a high ping in the
 * network.  Useful to test the behavior of asynchronism and
 * re-synchronization.
 */
@Mod.EventBusSubscriber(bus=Mod.EventBusSubscriber.Bus.MOD)
public class DebugLagCommand extends CommandDebug<DebugLagCommand>
{
  @SubscribeEvent
  public static void
  onRegister(final RegistryEvent.Register<CommandBase> event)
  {
    event.getRegistry().register(new DebugLagCommand());
  }
  private static final String _DEBUG_COMMAND_NAME = "lag";

  /**
   * A default constructor without any parameter must be implemented
   * to instanciate dummy objects.  It can be empty, but
   * <code>super(String debugCommandName)</code> must be called.
   */
  public DebugLagCommand()
  {
    super(DebugLagCommand._DEBUG_COMMAND_NAME);
  }

  @Override
  protected @Nullable ArgumentBuilder<CommandSource,?>
  requiredArguments()
  {
    return this.newArgument("seconds",
                            IntegerArgumentType.integer(1, 60));
  }

  @Override
  protected int onExec(CommandContext<CommandSource> context)
  {
    CommandSource cs = context.getSource();
    Integer seconds = context.getArgument("seconds", Integer.class);

    PlayerList allPlayers = cs.getServer().getPlayerList();

    allPlayers.sendMessage(new TextComponentDebug(
      "[%1$s] freezing server for %2$s seconds", this._DEBUG_COMMAND_NAME,
      seconds), true);

    try { Thread.sleep(1000*seconds); }
    catch (Exception e) {}

    allPlayers.sendMessage(new TextComponentDebug(
      "[%1$s] server is back", this._DEBUG_COMMAND_NAME), true);

    return Command.SINGLE_SUCCESS;
  }

  @Override
  protected @Nullable ArgumentBuilder<CommandSource,?>
  otherArguments()
  {
    return null;
  }

  @Override
  protected int onOtherExec(CommandContext<CommandSource> context)
  {
    CommandSource cs = context.getSource();

    return Command.SINGLE_SUCCESS;
  }
}
